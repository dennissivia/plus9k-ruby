require "octokit"
require "json"

class Plus9k
  def initialize(token:, event_path:, message: nil)
    raise "Invalid or missing token" if token.to_s.length.zero?

    @event_path = event_path
    @payload = JSON.parse(File.read(event_path), symbolize_names: true)
    @client = Octokit::Client.new(:access_token => token)
    @message = message.to_s.empty? ? default_message : message
  end

  def default_message
    filename = 'default-message.txt'
    path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'data', filename))
    File.read(path)
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
    puts "Adding message: #{repo}/#{issue_id} with message #{@message}"
    @client.add_comment(repo, issue_id, @message)
  end
end
