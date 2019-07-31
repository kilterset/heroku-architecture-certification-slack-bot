module SlashCommands
  NOT_FOUND = SlackResponse.new(text: 'Coming soon')

  COMMANDS_ROOT = Pathname(__dir__).join('slash_commands')
  COMMANDS = {}

  COMMANDS_ROOT.glob('*.rb').each do |command|
    require command
    name = command.basename('.rb').to_s
    COMMANDS[name] = const_get(name.capitalize)
  end

  COMMANDS.freeze

  module_function

  # Returns an approrpirate response for the request.
  def response_for(request)
    responder = responder_for(request)
    responder ? responder.response : NOT_FOUND
  end

  def responder_for(request)
    COMMANDS[request.command_name]&.new(request)
  end
end
