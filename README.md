# XEMX (Windows)

A plugin version of the Korg Electribe EMX-1. It plays the patterns from `.emx` SmartMedia card files and puts every control where it sits on the original front panel.

- Formats: VST3 and Standalone (x64)
- Loads `.emx` files with LOAD .EMX, by drag-and-drop, or from SHIFT + step 13. The card is saved inside the DAW project, and SAVE / WRITE export a new `.emx`.
- Drum samples come from your own EMX-1 sample folder or ZIP, picked with SAMPLES. By default it looks in `~/Downloads/ELECTRIBE`. No samples are included in this repo.
- Effects and output follow the service-manual block diagram: 3 FX slots with chain routing, audio-in thru, valve stage (TUBE GAIN), then master.

## Build

Requires Visual Studio 2022 and CMake 3.22 or later. JUCE 8.0.8 is downloaded automatically, or you can pass `-DJUCE_DIR=path`.

```
cmake -S . -B build -G "Visual Studio 17 2022" -A x64
cmake --build build --config Release
```

The output is in `build/XEMX_artefacts/Release/`. Copy `VST3/XEMX.vst3` to `C:\Program Files\Common Files\VST3`.

## Layout

- `Source/`: engine (`Engine`, `Voices`, `Fx`, `Dsp.h`), EMX file model (`EmxData`), panel UI (`PluginEditor`, `PanelWidgets.h`)
- `factory/FACTORY.EMX`: factory patterns built into the plugin
- `docs/EMX_FORMAT.md`: the decoded `.emx` format
- `tools/`: Node parser and the verifier against the EMX1Config log
- `player/`: browser player template
