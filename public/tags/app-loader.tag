<app-loader>
  <div class="content">
    <div class="close" onclick="{ close }">&times;</div>
    <div class="loader"></div>
    <span class="loader-text">matching...</span>
  </div>
  <script>
    this.close = () => {
      this.trigger('close')
    }
  </script>
  <style>
    :scope {
      position: fixed;
      z-index: 10000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0, 0, 0, 0.9);
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .content {
      text-align: center
    }

    .loader {
      border: 16px solid #f3f3f3;
      border-top: 16px solid #3498db;
      border-radius: 50%;
      width: 120px;
      height: 120px;
      animation: spin 2s linear infinite;
    }

    .loader-text {
      color: white;
    }

    .close {
      position: absolute;
      top: 15px;
      right: 25px;
      color: #f1f1f1;
      font-size: 40px;
      font-weight: bold;
      transition: 0.3s;
    }

    .close:hover,
    .close:focus {
      color: #bbb;
      text-decoration: none;
      cursor: pointer;
    }

    @keyframes spin {
      0% {
        transform: rotate(0deg);
      }

      100% {
        transform: rotate(360deg);
      }
    }
  </style>
</app-loader>