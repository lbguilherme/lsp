# Language Server Protocol for Crystal

This shard implement the Language Server Protocol. It has mappings for every protocol message and will do the JSON-RPC processing. It does not define the behavior of the language.

This is the basis to implement a Language Server using Crystal.

Code comes mostly from https://github.com/elbywan/crystalline, with some tweaks and improvements.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     lsp:
       github: lbguilherme/lsp
   ```

2. Run `shards install`

## Usage

```crystal
require "lsp/server"

private SERVER_CAPABILITIES = LSP::ServerCapabilities.new(
  # ...
)

server = LSP::Server.new(STDIN, STDOUT, SERVER_CAPABILITIES)
server.start(Controller.new)

private class Controller
  def on_init(init_params : LSP::InitializeParams) : Nil
  end

  def on_request(message : LSP::RequestMessage)
    nil
  end

  def on_notification(message : LSP::NotificationMessage) : Nil
  end

  def on_response(message : LSP::ResponseMessage, original_message : LSP::RequestMessage?) : Nil
  end
end
```
