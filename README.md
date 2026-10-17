# StillSpace: Distraction-Free Wellness on tvOS

StillSpace is a sophisticated tvOS application that transforms the television into a dedicated, distraction-free wellness environment. Built with SwiftUI, MVVM architecture, and AVFoundation, the app features dynamic breathing animations, personalized mood-based sessions, and seamless background video loops designed specifically for the living room.

## How to Build and Run the App

### Prerequisites
*   **Mac** running macOS Sonoma (or later).
*   **Xcode 15** (or later) installed.
*   **Testing Target:** The app is designed for the Apple TV. It can be run on a physical Apple TV 4K or tested locally using the **Apple TV 4K (3rd generation) Simulator** in Xcode.

### Installation Steps
1. **Clone the Repository:** 
   Download the ZIP or clone the repo using terminal:
   `git clone https://github.com/YourUsername/IT23168268-SE4041-Assignment-2-Part-B.git`
2. **Open the Project:** 
   Navigate into the downloaded folder and open `tvOSPrototype.xcodeproj`.
3. **Configure Media Assets (Important):** 
   Due to GitHub file size limits, high-resolution background videos are not included. Before running, ensure you add `.mp4` video files to the `Resources` folder in Xcode named according to the data models (e.g., `ocean_1.mp4`, `forest_1.mp4`).
4. **Build and Run:** 
   Select the **Apple TV 4K (3rd generation)** simulator from the destination menu at the top of Xcode. Press the **Play** button (`Cmd + R`) to build and run the app. *Note: Ensure your simulator window is set to 'Point Accurate' (Cmd + 2) for crisp rendering.*

---

## Interface Showcase

> **[📸 INSERT: Home Screen]**
> *The cinematic Home interface, featuring a prominent hero section and a bottom carousel of experiences.*

> **[📸 INSERT: Mood Selection Screen]**
> *The personalization interface where users define their current mood to calculate the optimal breathing pattern.*

> **[📸 INSERT: Breathing Studio - Inhale Phase]** | **[📸 INSERT: Breathing Studio - Hold Phase]**
> *The signature breathing engine featuring a dynamic, scaling orb and a warm progress ring.*

> **[📸 INSERT: Ambient Escape]**
> *The two-tier spatial navigation system overlaying a seamless, distraction-free video background.*

> **[📸 INSERT: My Journey]**
> *A unified history list and statistical summary of completed sessions, powered by local persistence.*

---

## 1. User Guide

StillSpace strictly adheres to tvOS human interface guidelines, utilizing the Siri Remote focus engine for intuitive, spatial navigation.

### How to Use the App:
1. **Begin a Session:** Launch the app and select 'Begin a quiet moment' from the Home screen.
2. **Personalize Your Experience:** Select your current mood (Overwhelmed, Restless, Tired, or Focused) and available time. The app will calculate a specific breathing pattern based on your selection.
3. **Breathe:** Follow the expanding and contracting orb in the Breathing Studio. Use the Siri Remote Play/Pause button to suspend the session at any time. The session must run for at least 5 seconds to be recorded.
4. **Explore Ambience:** Navigate to 'Ambient Escape' to browse scenic environments. Hover over a category to view specific scenes, and click to hide the UI for a full-screen, distraction-free video loop. Click any button on the remote to wake the interface back up.
5. **Track Your Journey:** View your total mindful minutes, longest session, and a chronological list of recent sessions in the 'My Journey' tab.

---

## 2. Technical Documentation

### Architecture & Tech Stack
*   **UI Framework:** SwiftUI (MVVM architecture, custom focus state tracking).
*   **Media Playback:** AVFoundation, `AVQueuePlayer`, and `AVPlayerLooper` bridged into SwiftUI via `UIViewRepresentable`.
*   **Local Persistence:** Data models conforming to `Codable`, saved locally via `UserDefaults`.
*   **State Management:** State machines driving complex UI animations based on the `SessionViewModel` breathing phases.

### Core Mechanisms
*   **Dynamic Animation Engine:** The Breathing Studio does not rely on static videos. The orb is rendered natively using SwiftUI shapes, gradients, and blur effects. Its scale and animation duration are dynamically driven by a Timer-based state machine in the ViewModel, which calculates (Inhale/Hold/Exhale) patterns based on user mood selection.
*   **Seamless Video Looping:** Standard SwiftUI `VideoPlayer` implementations force native playback controls onto the screen. To bypass this, StillSpace uses a custom `UIViewRepresentable` wrapper around `AVQueuePlayer`, ensuring background videos loop endlessly without triggering the Apple TV media timeline UI.
*   **Two-Tier Focus Navigation:** The Ambient Escape screen utilizes SwiftUI `@FocusState` to detect which category the user is hovering over with the Siri Remote, updating the sub-category list dynamically without requiring an explicit click.

---

## 3. In-Depth Report

### 3.1 Design Decisions
*   **Cinematic, Distraction-Free UI:** The Apple TV is a passive, immersive device. The UI was intentionally designed to fade away. By utilizing large serif typography, deep organic color palettes, and auto-hiding controls, the app respects the living room environment rather than treating it like a large phone screen.
*   **Replacing the "Pill" Aesthetic:** Initial prototypes relied heavily on rounded pill buttons and bulky 3D hover effects. This was refined into a cleaner, flat-highlight list system for the Journey view and squarer, compact cards for the Ambient navigation, aligning closer with modern tvOS design standards.
*   **Focus-Driven Interactions:** tvOS relies entirely on directional focus rather than touch. The interface was structured to ensure clear focus paths, preventing the user from getting "trapped" in UI dead ends.

### 3.2 Development Challenges & Solutions
1. **The Default "White Platter" Focus Glitch:**
   * *Challenge:* When implementing an invisible "Wake Catcher" button over the full screen to bring back the UI after the video faded out, tvOS automatically applied a blinding white focus background to the invisible button.
   * *Solution:* The giant Button was replaced with a `Color.clear.contentShape(Rectangle())` view combined with an `.onTapGesture`. This allowed the app to catch the remote click without triggering the native tvOS button-highlight styling.
2. **Video Audio Muting:**
   * *Challenge:* Initially, the `AVQueuePlayer` was muted to prevent conflicts, requiring a separate `AudioManager` for sound. 
   * *Solution:* Once embedded audio was added to the `.mp4` files, the architecture was simplified. The custom `LoopingVideoUIView` was updated to configure the `AVAudioSession` category to `.playback`, and the `AudioManager` was entirely deprecated in favor of native embedded audio.

### 3.3 Target Market & Differentiation
*   **The Problem:** Conventional wellness apps are used on personal devices (phones/tablets) where notifications, messages, and other apps constantly compete for attention. 
*   **The Solution:** StillSpace moves the experience to the television—a shared, large-format device historically used for passive entertainment—repurposing it into a calming focal point.
*   **Differentiator:** While competitors like *Calm* and *Apple Fitness+* offer TV apps, they function primarily as massive content libraries. StillSpace differentiates itself by focusing on a hyper-minimalist, distraction-free breathing tool with local persistence, prioritizing the immediate experience over browsing a catalog.

### 3.4 Future Roadmap & Reflection
Building for tvOS highlighted the stark difference between touch-first and focus-first design. Future iterations of StillSpace would integrate SwiftData for more robust persistence across iCloud, allowing sessions to sync back to an iOS companion app. Additionally, moving from looping videos to real-time generative 3D particles using RealityKit would allow the visual environment to respond dynamically to the user's specific breathing pace.

---
### Acknowledgements & Citations
*   *Background Videos & Audio:* Sourced from [Insert Your Source Here - e.g., Pexels / Envato Elements].
*   *Icons:* Apple SF Symbols.
