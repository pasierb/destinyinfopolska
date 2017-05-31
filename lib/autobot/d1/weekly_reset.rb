module Autobot::D1
  class WeeklyReset < Base

    ActivityData = Struct.new(:activity) do
      def get_binding
        binding
      end
    end

    def skull_description(display_name, fallback = nil)
      I18n.t(display_name.underscore.gsub(/\W+/, '_'), scope: 'destiny.d1.skull.description', default: fallback || display_name)
    end

    def bungie_image_url(image_path)
      ["https://www.bungie.net", image_path].join("")
    end

    def activity_template
      f = File.open(File.join(Rails.root, 'app/views/refinery/blog/posts/_weekly_activity.html.erb'))

      f.read
    end

    def weekly_crucible_html
      return @weekly_crucible_html if @weekly_crucible_html.present?

      hs = data['data']['activities']['weeklycrucible']

      activity_data = ActivityData.new({
        :image => bungie_image_url(hs['display']['image']),
        :icon => bungie_image_url(hs['display']['icon']),
        :title => hs['display']['advisorTypeCategory'],
        :subtitle => "TODO Playlist name"
      })

      ERB.new(activity_template, 0, "", "@weekly_crucible_html").result(activity_data.get_binding)
    end

    def heroic_strike_html
      return @heroic_strike_html if @heroic_strike_html.present?

      hs = data['data']['activities']['heroicstrike']

      activity_data = ActivityData.new({
        :image => bungie_image_url(hs['display']['image']),
        :icon => bungie_image_url(hs['display']['icon']),
        :title => hs['display']['advisorTypeCategory'],
        :tiers => hs['activityTiers'].map do |tier|
          {
            :name => tier['tierDisplayName'],
            :skull_categories => hs['extended']['skullCategories'].map do |category|
              {
                :title => category['title'],
                :modifiers => category['skulls'].map do |skull|
                  {
                    :icon => bungie_image_url(skull['icon']),
                    :name => skull['displayName'],
                    :description => skull_description(skull['displayName'], skull['description'])
                  }
                end
              }
            end
          }
        end
      })

      ERB.new(activity_template, 0, "", "@heroic_strike_html").result(activity_data.get_binding)
    end

    def nightfall_html
      return @nightfall_html if @nightfall_html.present?

      nf = data['data']['activities']['nightfall']

      activity_data = ActivityData.new({
        :image => bungie_image_url(nf['display']['image']),
        :icon => bungie_image_url(nf['display']['icon']),
        :title => 'Nightfall',
        :subtitle => nf['display']['advisorTypeCategory'],
        :tiers => nf['activityTiers'].map do |tier|
          {
            :name => tier['tierDisplayName'],
            :skull_categories => nf['extended']['skullCategories'].map do |category|
              {
                :title => category['title'],
                :modifiers => category['skulls'].map do |skull|
                  {
                    :icon => bungie_image_url(skull['icon']),
                    :name => skull['displayName'],
                    :description => skull_description(skull['displayName'], skull['description'])
                  }
                end
              }
            end
          }
        end
      })

      ERB.new(activity_template, 0, "", "@nightfall_html").result(activity_data.get_binding)
    end

    def raid_html
      return @raid_html if @raid_html.present?

      raid = data['data']['activities']['weeklyfeaturedraid']

      activity_data = ActivityData.new({
        :image => bungie_image_url(raid['display']['image']),
        :icon => bungie_image_url(raid['display']['icon']),
        :title => 'Raid name',
        :subtitle => raid['display']['advisorTypeCategory'],
        :tiers => raid['activityTiers'].map do |tier|
          {
            :name => tier['tierDisplayName'],
            :skull_categories => tier['skullCategories'].map do |category|
              {
                :title => category['title'],
                :modifiers => category['skulls'].map do |skull|
                  {
                    :icon => bungie_image_url(skull['icon']),
                    :name => skull['displayName'],
                    :description => skull_description(skull['displayName'], skull['description'])
                  }
                end
              }
            end
          }
        end
      })

      ERB.new(activity_template, 0, "", "@raid_html").result(activity_data.get_binding)
    end

    def post_body
      return @post_body if @post_body.present?

      f = File.open(File.join(Rails.root, 'app/views/refinery/blog/posts/_weekly_reset_template.html.erb'))

      ERB.new(f.read, 0, "", "@post_body").result(binding)
    end

    def post_teaser
      return @post_teaser if @post_teaser.present?

      f = File.open(File.join(Rails.root, 'app/views/refinery/blog/posts/_weekly_reset_teaser_template.html.erb'))

      ERB.new(f.read, 0, "", "@post_teaser").result(binding)
    end

    def post!
      Refinery::Blog::Post.create({
        user_id: user.id,
        title: "Weekly reset #{Time.now}",
        body: post_body,
        custom_teaser: "", #post_teaser,
        published_at: DateTime.now,
        draft: true
      })
    end

    def content_data
      return @content_data if @content_data.present?

      featured_raid = data['data']['activities']['weeklyfeaturedraid']

      @content_data = {
        weekly_raid: {
          name: "asdfdsaf",
          activity_name: featured_raid['display']['advisorTypeCategory'],
          image: bungie_image_url(featured_raid['display']['image']),
          raw: featured_raid
        }
      }
    end


    def data
      @data ||= client.get_public_advisors_v2
    end

  end
end
