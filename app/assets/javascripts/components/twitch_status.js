(function() {
  Vue.component('dip-twitch-status', {
    props: ['logins'],
    template: '<div>\
      <span v-for="login in logins" style="white-space: nobreak;">\
        <dip-twitch-user-status :login="login"></dip-twitch-user-status>\
      </span>\
    </div>'
  })

  Vue.component('dip-twitch-user-status', {
    props: ['login'],
    template: '<span>\
      <i class="fa fa-twitch" v-bind:class="twitchStatusClass"></i>\
      <strong>\
        <a v-bind:href="twitchAccountUrl" target="_twitch">{{login}}</a>\
      </strong>: \
      <span v-bind:class="twitchStatusClass">{{twitchStatus.stream ? "online" : "offline"}}</span>\
      <span></span>\
      <span v-if="twitchStatus.stream">\
        {{twitchStatus.stream.game}} <i class="fa fa-eye"></i>{{twitchStatus.stream.viewers}}\
        <small>- {{twitchStatus.stream.channel.status}}</small>\
      </span>\
    </span>',
    data: function() {
      return {
        inteval: null,
        twitchStatus: {}
      };
    },
    mounted: function() {
      var vm = this;

      vm.getUserStatus();
      (function() {
        vm.inteval = setInterval(function() {
          vm.getUserStatus();
        }, 60000);
      })()
    },
    beforeDestroy: function() {
      clearInterval(this.inteval);
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
