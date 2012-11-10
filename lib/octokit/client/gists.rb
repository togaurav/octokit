module Octokit
  class Client
    module Gists

      # List gists for a user or all public gists
      #
      # @param username [String] An optional user to filter listing
      # @return [Array<Hashie::Mash>] A list of gists
      # @example Fetch all gists for defunkt
      #   Octokit.gists('defunkt')
      # @example Fetch all public gists
      #   Octokit.gists
      # @see http://developer.github.com/v3/gists/#list-gists
      def gists(username=nil, options={})
        if username.nil?
          root.rels[:gists].get(options).data
        else
          user(username).rels[:gists].get(options).data
        end
      end
      alias :list_gists :gists

      # List public gists
      #
      # @return [Array<Hashie::Mash>] A list of gists
      # @example Fetch all public gists
      #   Octokit.public_gists
      # @see http://developer.github.com/v3/gists/#list-gists
      def public_gists(options={})
        root.rels[:public_gists].get(options).data
      end

      # List the authenticated user’s starred gists
      #
      # @return [Array<Hashie::Mash>] A list of gists
      def starred_gists(options={})
        root.rels[:starred_gists].get(options).data
      end

      # Get a single gist
      #
      # @param gist [String] ID of gist to fetch
      # @return [Hash::Mash] Gist information
      # @see http://developer.github.com/v3/gists/#get-a-single-gist
      def gist(gist, options={})
        options.merge! :uri => { :gist_id => Gist.new(gist) }
        root.rels[:gists].get(options).data
      end

      # Create a gist
      #
      # @param options [Hash] Gist information.
      # @option options [String] :description
      # @option options [Boolean] :public Sets gist visibility
      # @option options [Array<Hash>] :files Files that make up this gist. Keys
      #   should be the filename, the value a Hash with a :content key with text
      #   conent of the Gist.
      # @return [Hashie::Mash] Newly created gist info
      # @see http://developer.github.com/v3/gists/#create-a-gist
      def create_gist(options={})
        root.rels[:gists].post(options).data
      end

      # Edit a gist
      #
      # @param options [Hash] Gist information.
      # @option options [String] :description
      # @option options [Boolean] :public Sets gist visibility
      # @option options [Array<Hash>] :files Files that make up this gist. Keys
      #   should be the filename, the value a Hash with a :content key with text
      #   conent of the Gist.
      #
      #   NOTE: All files from the previous version of the
      #   gist are carried over by default if not included in the hash. Deletes
      #   can be performed by including the filename with a null hash.
      # @return
      #   [Hashie::Mash] Newly created gist info
      # @see http://developer.github.com/v3/gists/#edit-a-gist
      def edit_gist(gist, options={})
        uri_options = { :uri => { :gist_id => Gist.new(gist) } }
        root.rels[:gists].patch(options, uri_options).data
      end
      #
      # Star a gist
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicates if gist is starred successfully
      # @see http://developer.github.com/v3/gists/#star-a-gist
      def star_gist(gist, options={})
        gist(gist).rels[:star].put(options).status == 204
      end

      # Unstar a gist
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicates if gist is unstarred successfully
      # @see http://developer.github.com/v3/gists/#unstar-a-gist
      def unstar_gist(gist, options={})
        gist(gist).rels[:star].delete(options).status == 204
      end

      # Check if a gist is starred
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicates if gist is starred
      # @see http://developer.github.com/v3/gists/#check-if-a-gist-is-starred
      def gist_starred?(gist, options={})
        gist(gist).rels[:star].get(options).status == 204
      end

      # Fork a gist
      #
      # @param gist [String] Gist ID
      # @return [Hashie::Mash] Data for the new gist
      # @see http://developer.github.com/v3/gists/#fork-a-gist
      def fork_gist(gist, options={})
        gist(gist).rels[:fork].post(options).data
      end

      # Delete a gist
      #
      # @param gist [String] Gist ID
      # @return [Boolean] Indicating success of deletion
      # @see http://developer.github.com/v3/gists/#delete-a-gist
      def delete_gist(gist, options={})
        gist(gist).rels[:self].delete(options).status == 204
      end

      # List gist comments
      #
      # @param gist_id [Integer] Gist Id.
      # @return [Array<Hashie::Mash>] Array of hashes representing comments.
      # @see http://developer.github.com/v3/gists/comments/#list-comments-on-a-gist
      # @example
      #   Octokit.gist_comments(3528645)
      def gist_comments(gist_id, options={})
        gist(gist_id).rels[:comments].get(options).data
      end

      # Get gist comment
      #
      # @param gist_comment_id [Integer] Id of the gist comment.
      # @return [Hashie::Mash] Hash representing gist comment.
      # @see http://developer.github.com/v3/gists/comments/#get-a-single-comment
      # @example
      #   Octokit.gist_comment(451398)
      def gist_comment(gist_id, gist_comment_id, options={})
        options.merge! :uri => { :comment_id => gist_comment_id }
        gist(gist_id).rels[:comments].get(options).data
      end

      # Create gist comment
      #
      # Requires authenticated client.
      #
      # @param gist_id [Integer] Id of the gist.
      # @param comment [String] Comment contents.
      # @return [Hashie::Mash] Hash representing the new comment.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/gists/comments/#create-a-comment
      # @example
      #   @client.create_gist_comment(3528645, 'This is very helpful.')
      def create_gist_comment(gist_id, comment, options={})
        options.merge!({:body => comment})
        gist(gist_id).rels[:comments].post(options).data
      end

      # Update gist comment
      #
      # Requires authenticated client
      #
      # @param gist_comment_id [Integer] Id of the gist comment to update.
      # @param comment [String] Updated comment contents.
      # @return [Hashie::Mash] Hash representing the updated comment.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/gists/comments/#edit-a-comment
      # @example
      #   @client.update_gist_comment(3528645, ':heart:')
      def update_gist_comment(gist_id, gist_comment_id, comment, options={})
        options.merge!({:body => comment})
        uri_options = {:uri => { :comment_id => gist_comment_id } }
        gist(gist_id).rels[:comments].patch(options, uri_options).data
      end

      # Delete gist comment
      #
      # Requires authenticated client.
      #
      # @param gist_comment_id [Integer] Id of the gist comment to delete.
      # @return [Boolean] True if comment deleted, false otherwise.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/gists/comments/#delete-a-comment
      # @example
      #   @client.delete_gist_comment(586399)
      def delete_gist_comment(gist_id, gist_comment_id, options={})
        uri_options = {:uri => { :comment_id => gist_comment_id } }
        gist(gist_id).rels[:comments].delete(options, uri_options).status == 204
      end

    end
  end
end
