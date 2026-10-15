# MargyT Custom Background plugin

This folder contains the source for the `catsdevs.custombackground` plugin.

## Build

The workflow `.github/workflows/build-margyt-plugin.yml` checks out the upstream MargyT project, copies this plugin into its examples directory, and runs the documented `python -m margyt.plugin examples/custom-background` build command.

After the workflow succeeds, download the `CustomBackgroundPlugin-mtp` artifact from the Actions run.

## Limitations

The plugin uses MargyT's `onColour(int)` hook. It changes only a small set of known dark surface colour constants routed through that hook; it cannot guarantee every TikTok background is changed. Custom colours use `#RRGGBB` or `#AARRGGBB`.
