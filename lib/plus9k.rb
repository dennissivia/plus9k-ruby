require "octokit"
require "json"

class Plus9k
  def initialize(token:, event_path:, message: nil)
    raise "Invalid or missing token" if token.to_s.length.zero?

    @event_path = event_path
    @payload = JSON.parse(File.read(event_path), symbolize_names: true)
    @client = Octokit::Client.new(:access_token => token)
    @message = message || default_message
  end

  def default_message
    <<~MESSAGE
      Thanks for supporting this discussion by sharing your opinion. :heart:
      Did you know? Dedicated `+1`-comments can make it hard to follow the discussion.
      Sharing your support via emoji reactions on comments avoids that problem and helps us get a complete picture of everybody's opinion.
      Make sure to use a reaction next time to make sure your vote is not lost.
    MESSAGE
  end

  def run()
    content = @payload.dig(:comment, :body)
    if content == "+1"
      handle_plus_one()
    else
      puts "this is a normal comment: #{content}"
    end
  end

  private

  def handle_plus_one
    issue_id = @payload.fetch(:issue).fetch(:number)
    repo = @payload.fetch(:repository).fetch(:full_name)

    if (!already_replied?(repo, issue_id))
      reply(repo, issue_id)
    end
  end

  def already_replied?(repo, issue_id)
    false
    # recent_comments = @client.issue_comments(nwo, issue_id)
    # find my own comments in there...
  end

  def reply(repo, issue_id)
    puts "Adding message: #{repo}/#{issue_id}"
    @client.add_comment(repo, issue_id, @message)
  end
end
