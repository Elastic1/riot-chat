firebase.initializeApp({
  apiKey: 'AIzaSyCMF3yd0nOlb6-Wapj27m7Cr7WVqr_Reo4',
  authDomain: 'riot-chat-3ca96.firebaseapp.com',
  databaseURL: 'https://riot-chat-3ca96.firebaseio.com',
  projectId: 'riot-chat-3ca96',
  storageBucket: 'riot-chat-3ca96.appspot.com',
  messagingSenderId: '697499696975'
})

const database = firebase.database()
const auth = firebase.auth()

class Store {
  constructor() {
    riot.observable(this)
    this.user = {}
    this.chats = []
    this.matching = {
      connected: false
    }
  }

  async createUser(name) {
    const { user } = await firebase.auth().signInAnonymously()
    const userRef = database.ref('users').child(user.uid)
    await userRef.set({ name })
    userRef.onDisconnect().remove()
    this.user = { 
      id: user.uid, 
      name 
    }
    this.trigger('user:change', this.user)
  }

  async createMatching(userId) {
    const newMatchingRef = await database.ref('matching').push({ 
      user1: userId, 
      connected: false 
    })
    newMatchingRef.onDisconnect().remove()
    this.matching.id = newMatchingRef.key
    newMatchingRef.once('child_changed', async () => {
      await database.ref('users').child(auth.currentUser.uid).update({ 
        mch_id: this.matching.id 
      })
      this.matching.connected = true
      this.trigger('matching:change', this.matching)
    })
  }

  async getMatching() {
    const matchingRef = database.ref('matching').orderByChild('connected').equalTo(false).ref
    const data = (await matchingRef.once('value')).val()
    for (const key in data) {
      if (data.hasOwnProperty(key)) {
        const ref = matchingRef.child(key)
        ref.onDisconnect().remove()
        const { committed, snapshot } = await ref.transaction(matching => {
          if (matching == null)
            return { user1: this.user.id, connected: true }
          if (matching.connected)
            return
          return { user2: this.user.id, connected: true }
        })


        if (committed) {
          await database.ref('users').child(auth.currentUser.uid).update({ 
            mch_id: key 
          })
          this.matching.connected = true
          this.matching.id = key
          this.trigger('matching:change', this.matching)
          break
        } else {
          const newMatchingRef = snapshot.ref
          newMatchingRef.onDisconnect().remove()
          this.matching.id = snapshot.key
          newMatchingRef.once('child_changed', async () => {
            await database.ref('users').child(auth.currentUser.uid).update({ 
              mch_id: this.matching.id 
            })
            this.matching.connected = true
            this.trigger('matching:change', this.matching)
          })
        }
      }
    }
  }

  async initMatching(name) {
    if (this.matching.id) return;
    await this.createUser(name)
    await this.getMatching()
    if (!this.matching.connected) {
      await this.createMatching(this.user.id)
    }
  }

  async initChat() {
    const chatRef = database.ref('chat').child(this.matching.id)
    chatRef.onDisconnect().remove()
    const snapshot = await chatRef.once('value')
    this.chats = snapshot.val() || []
    this.trigger('chats:change', this.chats)
    chatRef.on('child_added', snapshot => {
      const chat = snapshot.val()
      this.chats.push(chat)
      this.trigger('chats:change', this.chats)
    })
    database.ref('chat').once('child_removed', snapshot => {
      this.trigger('chat:disconnect')
    })
  }

  async sendMessage(text) {
    const chatRef = database.ref('chat').child(this.matching.id)
    const { id, name } = this.user
    const time = new Date().getTime()
    await chatRef.push({ uid: id, name, text, time })
  }

  async destroyMatching() {
    await database.ref('matching').child(this.matching.id).remove()
    this.matching = { connected: false }
  }

  async destroyChat() {
    await database.ref('chat').child(this.matching.id).remove()
    await database.ref(`users/${auth.currentUser.uid}/mch_id`).remove()
    this.chats = []
  }
}

riot.compile(() => {
  riot.mixin({ store: new Store() })
  riot.mount('app-root')
  route.start(true)
  route('home', null, false)
})