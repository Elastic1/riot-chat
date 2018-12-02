<app-home>
  <h1 class="title">Riot Chat</h1>
  Name : <input class="name" type="text" ref="name" value="名無し">
  <button class="start-btn" onclick="{ onStartClick }">Start</button>
  <app-loader show="{ displayLoader }" ref="loader"></app-loader>
  <script>
    const store = this.store
    store.on('matching:change', matching => {
      route('chat')
    })
    
    this.displayLoader = false

    this.onStartClick = () => {
      this.displayLoader = true
      store.initMatching(this.refs.name.value)
    }

    this.on('mount', () => {
      const loader = this.refs.loader
      loader.on('close', () => {
        if (store.matching.id) {
          this.displayLoader = false
          this.update()
          store.destroyMatching()
        }
      })
    })
    
  </script>

  <style>

    .title {
      margin-top: 50px;
      text-align: center
    }

    .name {
      padding: 6px;
      border: 1px solid #ddd;
      margin-top: 20px;
    }

    .start-btn {
      width: 100%;
      display: block;
      border: 2px solid #f44336;  
      background-color: white;
      color: red;
      padding: 14px 28px;
      margin-top: 10px;
      font-size: 16px;
      cursor: pointer;
    }

    .start-btn:hover {
      background: #f44336;
      color: white;
    }
  </style>
</app-home>