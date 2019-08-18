# frozen_string_literal: true

require "octokit"
require "json"

class Plus9k
  def initialize(token:, event_path:, message: nil)
    raise "Invalid or missing token" if token.to_s.length.zero?

    @event_path = event_path
    @payload = JSON.parse(File.read(event_path), symbolize_names: true)
    @client = Octokit::Client.new(access_token: token)
    @message = message.to_s.empty? ? default_message : message
  end

  def default_message
    filename = 'default-message.txt'
    path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'data', filename))
    File.read(path)
  end

  def run
    content = @payload.dig(:comment, :body)
    if content == "+1"
      handle_plus_one
    else
      puts "This is a regular comment. Doing nothing."
    end
  end

  private

  def handle_plus_one
    issue = @payload.fetch(:issue)
    issue_id = issue.fetch(:number)
    repo = @payload.fetch(:repository).fetch(:full_name)

    reply(repo, issue_id) unless ignore_event?(repo, issue)
  end

  def ignore_event?(repo, issue)
    @payload.fetch(:action) == 'deleted' || already_replied?(repo, issue)
  end

  def already_replied?(_repo, _issue)
    false
    # recent_comments = @client.issue_comments(nwo, issue.fetch(:id))
    # find my own comments in there...
  end

  def reply(repo, issue_id)
    @client.add_comment(repo, issue_id, @message)
  end
end
