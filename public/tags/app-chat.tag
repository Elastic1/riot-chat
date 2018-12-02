<app-chat>
  <div class="chat-header">
    <span class="chat-title">CHAT!</span>
    <button style="float: right" onclick="{ exit }">exit</button>
  </div>
  <div class="chat-body">

    <div each="{ chat,i in chats }" class="message-card">
      <div class="image">
        <svg data-jdenticon-value="{ chat.uid }" width="40" height="40"></svg>
      </div>
      <div class="message-content">
        <span class="name">{ chat.name }</span>
        <small class="time">{ formatTime(chat.time) }</small>
        <div class="text">{ chat.text }</div>
      </div>
    </div>

  </div>
  <div class="chat-footer">
    <textarea rows="1" oninput="{ autoExpand }" ref="text" placeholder="write here.."></textarea>
    <div style="text-align: right">
      <button onclick="{ sendMessage }">send</button>
    </div>
  </div>
  <script>
    const store = this.store
    let maxExpandHeight = 0

    store.on('chats:change', chats => {
      this.chats = chats
      this.update()
      jdenticon()
    })

    store.on('chat:disconnect', () => {
      route('home')
    })

    this.chats = []

    this.on('mount', () => {
      jdenticon()
      maxExpandHeight = this.refs.text.scrollHeight * 5
      store.initChat()
    })

    this.on('unmount', async () => {
      await store.destroyChat()
      store.destroyMatching()
      store.off('chats:change')
    })

    this.autoExpand = (e) => {
      const el = e.target
      if (maxExpandHeight <= el.scrollHeight) return
      el.style.height = 'inherit'
      el.style.height = el.scrollHeight + 'px'
    }

    this.formatTime = (time) => {
      const date = new Date(time)
      return `${date.getHours()}:${date.getMinutes()}`
    }

    this.sendMessage = () => {
      store.sendMessage(this.refs.text.value)
      this.refs.text.value = ''
    }

    this.exit = () => {
      route('home')
    }
  </script>
  <style>
    :scope {
      display: flex;
      flex-direction: column;
      position: fixed;
      left: 0;
      bottom: 0;
      right: 0;
      top:0;
    }

    .chat-header {
      background-color: #13c086;
      height: 45px;
      width: 100%;
      box-shadow: 0 2px 2px -3px rgba(0, 0, 0, .12), 0 2px 10px 1px rgba(0, 0, 0, .12);
    }

    .chat-title {
      margin: 2em;
    }

    .chat-body {
      overflow-y: scroll;
      overflow-x: hidden;
      flex: 1;
      position: relative;
    }

    .message-card {
      margin-top: .6em;
      padding: 0 .4em;
      padding-top: .6em;
      display: flex;
    }

    .image {
      display: inline-block;
      display: flex;
    }

    .name {
      font-weight: bold;
    }

    .time {
      color: rgb(179, 179, 179)
    }

    .text {
      word-break: all;
      white-space: pre-wrap;
    }

    .message-content {
      margin-left: .3em;
    }

    .chat-footer {
      bottom: 0;
      width: 100%;
      box-shadow: 0 5px 5px -3px rgba(0, 0, 0, .2), 0 8px 10px 1px rgba(0, 0, 0, .14), 0 3px 14px 2px rgba(0, 0, 0, .12);
    }

    .chat-footer textarea {
      resize: none;
      width: 100%;
      height: inherit;
      padding: 2px 4px;
      line-height: 1.5em;
      font-size: 1.2em;
      vertical-align: top;
      border: none;
    }

    .chat-footer textarea:focus {
      outline: none
    }
  </style>
</app-chat>