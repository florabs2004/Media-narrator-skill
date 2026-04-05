---
name: media-narrator
description: Automates adding high-quality voice-overs to videos using macOS native tools (say, afconvert) and a custom Swift-based media merger. Use when you need to narrate a demo video, tutorial, or presentation with professional-sounding AI voices.
---

# Media Narrator

This skill automates the process of adding high-quality, professional voice-overs to videos using native macOS capabilities. It is designed to work even when third-party tools like `ffmpeg` are blocked by system security (e.g., Santa).

## Why Use This Skill?

*   **Saves Time:** Instead of manually recording audio, syncing it in a video editor, and exporting, you can do it with a single natural language command.
*   **Professional Results:** It ensures every demo video or tutorial has a consistent, high-quality voice (like the modern macOS "Eddy" or "Flo" voices) and perfect pacing.

## How to Use

1.  **Install the Skill:**
    ```bash
    gemini skills install https://github.com/florabs2004/Media-narrator-skill
    ```

2.  **Ask Gemini to Narrate:**
    Once installed, you can simply tell Gemini what you want to do:
    > *"I have a 30-second screen recording called `tutorial.mp4`. Can you write a short script and add a professional voice-over to it?"*

    Gemini will automatically analyze the video duration, generate the audio using high-quality macOS voices, and merge it using the bundled Swift script.

## Workflow

### 1. Analysis
Before generating audio, understand the video's timing:
- **Duration**: Use `mdls -name kMDItemDurationSeconds <video_path>` to find the exact length.
- **Content**: If the video is not described, use `ffmpeg` (if available) to extract frames for analysis, or ask the user for a summary.

### 2. Voice Selection
Consult `references/voices.md` for a list of high-quality macOS voices. 
- **Preferred Voices**: "Eddy (English (US))" or "Flo (English (US))" for a modern, Siri-like tone.
- **Check Availability**: Run `say -v '?'` to see which high-quality voices are installed.

### 3. Audio Generation
Generate the voice-over using the `say` command.
- **Format**: Output to AIFF first (`-o output.aiff`).
- **Pacing**: Use `[[rate <WPM>]]` to adjust speed. Aim for ~160-180 WPM.
- **Check Duration**: Use `afinfo output.aiff | grep duration` to ensure the audio fits the video.
- **Conversion**: Convert AIFF to M4A (AAC) using `afconvert -f m4af -d aac output.aiff output.m4a`.

### 4. Merging
Use the bundled Swift script to merge the audio and video. This bypasses `ffmpeg` restrictions by using the native `AVFoundation` framework.

**Command:**
```bash
swift scripts/merge_media.swift <video_path> <audio_path> <output_path>
```

## Tips for High-Quality Narrations
- **Shorten Scripts**: If the audio is too long, don't just increase the rate; edit the script for brevity.
- **Pauses**: Use `[[slnc 500]]` to add half-second pauses between major points.
- **Cleanup**: Always delete temporary `.aiff` and `.m4a` files after the merge is successful.
- **Naming**: Use descriptive output names (e.g., `video-with-voiceover.mp4`).

## Handling Blocked Tools
If `ffmpeg` or `ffprobe` are blocked by security software (e.g., Santa):
1. Use `mdls` for metadata (duration, resolution).
2. Use `afinfo` and `afconvert` for audio processing.
3. Use the bundled `scripts/merge_media.swift` for the final composition.
