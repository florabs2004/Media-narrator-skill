# macOS High-Quality Voices Reference

When creating voice-overs with the `say` command, prioritize these modern, high-quality voices for a professional feel.

## Recommended Voices

| Voice | Region | Tone |
| :--- | :--- | :--- |
| **Eddy** | en_US / en_GB | Modern, Siri-like, natural, confident. |
| **Flo** | en_US / en_GB | Modern, Siri-like, pleasant, informative. |
| **Daniel** | en_GB | Authoritative, British, professional. |
| **Samantha** | en_US | Clear, classic American narrator. |
| **Reed** | en_US / en_GB | Measured, modern, steady. |
| **Rocko** | en_US / en_GB | Punchy, modern, energetic. |
| **Shelley** | en_US / en_GB | Warm, modern, professional. |

## Usage Guide

Use the `say` command with the `-v` flag to specify the voice and the `-o` flag to output to a file:

```bash
say -v "Eddy (English (US))" -o voiceover.aiff "Your script goes here."
```

### Scripting Tags
Use these tags inside the script string to control the delivery:
- `[[rate <WPM>]]`: Adjust the speed (e.g., `[[rate 180]]`). Default is around 175.
- `[[slnc <ms>]]`: Insert a silent pause (e.g., `[[slnc 1000]]` for 1 second).
- `[[emph +]]` / `[[emph -]]`: Increase or decrease emphasis on the next word.
- `[[pbas <Hz>]]`: Adjust the pitch.

## Listing All Voices
To see all available voices on the current system, run:
```bash
say -v '?'
```
