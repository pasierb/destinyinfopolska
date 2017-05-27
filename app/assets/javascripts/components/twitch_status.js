(function() {
  Vue.component('dip-twitch-status', {
    props: ['logins'],
    template: '<div>\
      <ul class="list-unstyled">\
        <li v-for="login in logins">\
          <dip-twitch-user-status :login="login"></dip-twitch-user-status>\
        </li>\
      </ul>\
    </div>'
  })

  Vue.component('dip-twitch-user-status', {
    props: ['login'],
    template: '<div>\
      <i class="fa fa-twitch" v-bind:class="twitchStatusClass"></i>\
      <strong><a v-bind:href="twitchAccountUrl" target="_twitch">{{login}}</a></strong>: <span v-bind:class="twitchStatusClass">{{twitchStatus.stream ? "online" : "offline"}}</span>\
      <span v-if="twitchStatus.stream">({{twitchStatus.stream.game}})</span>\
    </div>',
    data: function() {
      return {
        twitchStatus: {}
      };
    },
    mounted: function() {
      this.getUserStatus();
    },
    computed: {
      twitchAccountUrl: function() {
        var vm = this;

        return ["http://www.twitch.tv", vm.login].join("/");
      },
      twitchStatusClass: function() {
        var vm = this;
        var cssClass = [];

        cssClass.push(vm.twitchStatus.stream ? 'text-success' : 'text-danger')

        return cssClass;
      }
    },
    methods: {
      getUserStatus: function() {
        var vm = this;

        $.ajax({
          url: ["https://api.twitch.tv/kraken/streams/", vm.login].join(''),
          data: {
            "client_id": dip.twitchClientId
          },
          jsonp: "callback",
          dataType: "jsonp",
          beforeSend: function(xhr) {
            xhr.setRequestHeader('Client-ID', '1h1v6pbv9lx8x4imco0srmynbrm49u');
            xhr.setRequestHeader('Accept', 'application/vnd.twitchtv.v5+json');
          },
          success: function(data) {
            vm.twitchStatus = data;
          }
        });
      }
    }
  })
})();
