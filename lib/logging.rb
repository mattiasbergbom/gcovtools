require 'logger'

module GCOVTOOLS

  @@logger = Logger.new(STDERR)
  @@logger.level = Logger::WARN

  @@original_formatter = Logger::Formatter.new
  @@logger.formatter = proc { |severity, datetime, progname, msg|
    if not msg.nil?
      "#{msg}\n"
    end
  }

  def self.logger
    @@logger
  end

end
