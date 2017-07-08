;(function() {
  Vue.component('dip-youtube-video', {
    props: ["channelId"],
    template: '<div>\
      <div class="video-url-slot"><slot></slot></div>\
      <div v-bind:id="playerId">{{videoString}}</div>\
    </div>',
    data: function() {
      var vm = this;

      return {
        apiKey: window.dip.youtubeApiKey,
        playerId: ['dip', 'yt', 'player', Date.now()].join("-"),
        videoString: null,
        player: null
      }
    },
    methods: {
      initPlayer: function(videoId) {
        var vm = this;

        vm.player = new YT.Player(vm.playerId, {
          videoId: videoId,
          width: $(vm.$el).width()
        });
      },
      getLatestVideoIdFromChannel: function(cb) {
        $.get({
          url: "https://www.googleapis.com/youtube/v3/search",
          data: {
            part: "snippet",
            channelId: "UCtePAeF_4XYjFYlWyJ3VotA",
            order: "date",
            key: apiKey
          }
        }, function(data) {
          cb(data.items[0].id.videoId);
        })
      }
    },
    mounted: function() {
      var vm = this;
      var videoString = $(".video-url-slot", vm.$el).html();

      vm.$root.vent.$on('onYouTubePlayerAPIReady', function() {

        if (videoString) {
          vm.initPlayer(videoString);
        } else if (vm.channelId) {
          vm.getLatestVideoIdFromChannel(function(videoId) {
            vm.initPlayer(videoId);
          })
        }
      });
    }
  });
})();
