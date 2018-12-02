<app-root>
  <div class="app-router" ref="appRouter"></div>
  <script>
    this.on('mount', () => {
      const router = this.refs.appRouter

      route('home', () => {
        riot.mount(router, 'app-home')
      })
  
      route('chat', () => {
        riot.mount(router, 'app-chat')
      })
    })
  </script>
  <style>
    .app-router {
      max-width: 500px;
      width: 100%;
      margin: 0 auto;
    }
  </style>
</app-root>