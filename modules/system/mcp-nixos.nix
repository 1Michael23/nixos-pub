# mcp-nixos (used by the OpenCode MCP server) still depends on fastmcp 3.x,
# which nixpkgs marks broken when built against mcp 2.x (McpError was renamed).
# NixOS/nixpkgs#577109 was closed unmerged; #577124 only pins mcp_1 for
# music-assistant. Keep this overlay until fastmcp 4 lands (#563493) and
# mcp-nixos is updated to a version that uses it.
_:

{
  nixpkgs.overlays = [
    (_final: prev: {
      mcp-nixos = prev.mcp-nixos.override {
        python3Packages = prev.python3Packages.override {
          overrides = self: super: {
            fastmcp-slim = super.fastmcp-slim.override { mcp = self.mcp_1; };
            fastmcp = super.fastmcp.override { inherit (self) fastmcp-slim; };
          };
        };
      };
    })
  ];
}
