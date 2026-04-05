import Foundation
import AVFoundation

func merge(videoPath: String, audioPath: String, outputPath: String) {
    let videoUrl = URL(fileURLWithPath: videoPath)
    let audioUrl = URL(fileURLWithPath: audioPath)
    let outputUrl = URL(fileURLWithPath: outputPath)

    if FileManager.default.fileExists(atPath: outputPath) {
        try? FileManager.default.removeItem(atPath: outputPath)
    }

    let videoAsset = AVURLAsset(url: videoUrl)
    let audioAsset = AVURLAsset(url: audioUrl)

    let composition = AVMutableComposition()

    guard let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
        print("Error: Could not create video track")
        exit(1)
    }

    // Load tracks (legacy way for quick scripts, works on current macOS)
    let assetVideoTracks = videoAsset.tracks(withMediaType: .video)
    guard let assetVideoTrack = assetVideoTracks.first else {
        print("Error: No video track found in \(videoPath)")
        exit(1)
    }

    let videoDuration = videoAsset.duration
    do {
        try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoDuration), of: assetVideoTrack, at: .zero)
    } catch {
        print("Error inserting video: \(error)")
        exit(1)
    }

    guard let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
        print("Error: Could not create audio track")
        exit(1)
    }

    let assetAudioTracks = audioAsset.tracks(withMediaType: .audio)
    guard let assetAudioTrack = assetAudioTracks.first else {
        print("Error: No audio track found in \(audioPath)")
        exit(1)
    }

    let audioDuration = audioAsset.duration
    do {
        try audioTrack.insertTimeRange(CMTimeRange(start: .zero, duration: audioDuration), of: assetAudioTrack, at: .zero)
    } catch {
        print("Error inserting audio: \(error)")
        exit(1)
    }

    videoTrack.preferredTransform = assetVideoTrack.preferredTransform

    guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
        print("Error: Could not create export session")
        exit(1)
    }

    exportSession.outputURL = outputUrl
    exportSession.outputFileType = .mp4

    let semaphore = DispatchSemaphore(value: 0)
    exportSession.exportAsynchronously {
        if exportSession.status == .completed {
            print("Success: Exported to \(outputPath)")
        } else {
            print("Error: Export failed - \(String(describing: exportSession.error?.localizedDescription))")
        }
        semaphore.signal()
    }
    semaphore.wait()
}

let args = CommandLine.arguments
if args.count < 4 {
    print("Usage: swift merge_media.swift <videoPath> <audioPath> <outputPath>")
    exit(1)
}

merge(videoPath: args[1], audioPath: args[2], outputPath: args[3])
