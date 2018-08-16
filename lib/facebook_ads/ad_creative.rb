# frozen_string_literal: true

module FacebookAds
  # Ad ad creative has many ad images and belongs to an ad account.
  # https://developers.facebook.com/docs/marketing-api/reference/ad-creative
  class AdCreative < Base
    FIELDS               = %w[id name object_story_id object_story_spec object_type thumbnail_url status].freeze
    CALL_TO_ACTION_TYPES = %w[SHOP_NOW INSTALL_MOBILE_APP USE_MOBILE_APP SIGN_UP DOWNLOAD BUY_NOW NO_BUTTON].freeze

    class << self
      def photo(name:, page_id:, instagram_actor_id: nil, message:, link:, app_link: nil, link_title:, image_hash:, call_to_action_type:, link_description: nil)
        object_story_spec = {
          'page_id' => page_id, # 300664329976860
          'instagram_actor_id' => instagram_actor_id, # 503391023081924
          'link_data' => {
            'name' => link_title,
            'description' => link_description,
            'link' => link, # https://tophatter.com/, https://itunes.apple.com/app/id619460348, http://play.google.com/store/apps/details?id=com.tophatter
            'message' => message,
            'image_hash' => image_hash,
            'call_to_action' => {
              'type' => call_to_action_type,
              'value' => {
                # 'application' =>,
                'link' => link,
                'app_link' => app_link
              }
            }
          }
        }

        {
          name: name,
          object_story_spec: object_story_spec.to_json
        }
      end

      # https://developers.facebook.com/docs/marketing-api/guides/videoads
      def carousel(name:, page_id:, instagram_actor_id: nil, link:, app_link: nil, message:, assets:, call_to_action_type:, multi_share_optimized:, multi_share_end_card:)
        object_story_spec = {
          'page_id' => page_id, # 300664329976860
          'instagram_actor_id' => instagram_actor_id, # 503391023081924
          'link_data' => {
            'link' => link, # https://tophatter.com/, https://itunes.apple.com/app/id619460348, http://play.google.com/store/apps/details?id=com.tophatter
            'message' => message,
            'call_to_action' => {
              'type' => call_to_action_type,
              'value' => {
                'link' => link,
                'app_link' => app_link
              }
            },
            'child_attachments' => assets.collect do |asset|
              {
                'link' => asset[:link] || link,
                'image_hash' => asset[:hash],
                'name' => asset[:title],
                # 'description' => asset[:title],
                'call_to_action' => { # Redundant?
                  'type' => call_to_action_type,
                  'value' => {
                    'link' => asset[:link] || link,
                    'app_link' => asset[:app_link] || app_link
                  }
                }
              }
            end,
            'multi_share_optimized' => multi_share_optimized,
            'multi_share_end_card' => multi_share_end_card
          }
        }

        {
          name: name,
          object_story_spec: object_story_spec.to_json
        }
      end

      def product_set(name:, page_id:, link:, message:, headline:, description:, product_set_id:)
        {
          name: name,
          object_story_spec: {
            page_id: page_id,
            template_data: {
              description: description,
              link: link,
              message: message,
              name: headline
            }
          },
          template_url: link,
          product_set_id: product_set_id
        }
      end

      def link(name:, title:, body:, link_url:, image_hash:, page_id:)
        object_story_spec = {
          'page_id' => page_id,
          'link_data' => {
            'name' => title,
            'message' => body,
            'link' => link_url,
            'image_hash' => image_hash
          }
        }

        {
          name: name,
          object_story_spec: object_story_spec.to_json
        }
      end
    end
  end
end
