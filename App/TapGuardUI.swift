import SwiftUI

/// Model representing an app that can be guarded.
struct GuardedApp: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var iconName: String
    var lastOpenedMinutes: Int? = nil
}

/// Main entry point for the TapGuard demo.
/// Note: In a real project you would split each screen into its own file.
struct TapGuardUI: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/// Root view with navigation.  It holds the app-wide state.
struct ContentView: View {
    @State private var guardedApps: [GuardedApp] = []
    @State private var guardEnabled: Bool = true
    @State private var showingPaywall: Bool = false

    var body: some View {
        NavigationStack {
            HomeView(guardedApps: $guardedApps,
                     guardEnabled: $guardEnabled,
                     showingPaywall: $showingPaywall)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .chooseApps:
                        ChooseAppsView(guardedApps: $guardedApps, showingPaywall: $showingPaywall)
                    case .rules:
                        GuardRulesView()
                    case .paywall:
                        PaywallView()
                    }
                }
        }
    }

    enum Route: Hashable {
        case chooseApps
        case rules
        case paywall
    }
}

/// Home screen showing the main toggle and summary of guarded apps.
struct HomeView: View {
    @Binding var guardedApps: [GuardedApp]
    @Binding var guardEnabled: Bool
    @Binding var showingPaywall: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("TapGuard")
                        .font(.largeTitle.bold())
                    Text("Stop opening apps on autopilot")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top)

                // Toggle card
                Toggle(isOn: $guardEnabled) {
                    Text(guardEnabled ? "TapGuard is On" : "TapGuard is Off")
                        .font(.headline)
                }
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))

                // Summary card
                VStack(alignment: .leading, spacing: 8) {
                    Text("Guarded Apps")
                        .font(.headline)
                    if guardedApps.isEmpty {
                        Text("No guarded apps yet").foregroundStyle(.secondary)
                    } else {
                        ForEach(guardedApps.prefix(3)) { app in
                            HStack {
                                Image(systemName: app.iconName)
                                Text(app.name)
                                Spacer()
                            }
                        }
                        if guardedApps.count > 3 {
                            Text("and \(guardedApps.count - 3) more…")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Button(action: {}) {
                        NavigationLink(value: ContentView.Route.chooseApps) {
                            Label("Choose Apps", systemImage: "plus.circle")
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))

                // Rules card
                VStack(alignment: .leading, spacing: 8) {
                    Text("Guard Rules")
                        .font(.headline)
                    Text("Configure how TapGuard should ask before opening a guarded app.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    NavigationLink(value: ContentView.Route.rules) {
                        Label("Set Rules", systemImage: "chevron.right")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            }
            .padding()
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: ContentView.Route.paywall) {
                    Image(systemName: "crown")
                }
            }
        }
    }
}

/// Choose Apps screen allows selecting apps to guard.
/// In this simplified demo we use a static list of example apps.
struct ChooseAppsView: View {
    @Binding var guardedApps: [GuardedApp]
    @Binding var showingPaywall: Bool
    
    // Sample available apps to guard
    let availableApps: [GuardedApp] = [
        GuardedApp(name: "Instagram", iconName: "camera.fill"),
        GuardedApp(name: "TikTok", iconName: "music.note"),
        GuardedApp(name: "Twitter", iconName: "bird.fill"),
        GuardedApp(name: "YouTube", iconName: "play.rectangle.fill"),
        GuardedApp(name: "Facebook", iconName: "f.circle.fill")
    ]
    
    var body: some View {
        List {
            Section(header: Text("Guarded")) {
                if guardedApps.isEmpty {
                    Text("No apps guarded yet").foregroundStyle(.secondary)
                }
                ForEach(guardedApps) { app in
                    HStack {
                        Image(systemName: app.iconName)
                        Text(app.name)
                        Spacer()
                        Button(role: .destructive) {
                            if let index = guardedApps.firstIndex(of: app) {
                                guardedApps.remove(at: index)
                            }
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                    }
                }
            }
            Section(header: Text("Add App")) {
                ForEach(availableApps) { app in
                    Button {
                        addApp(app)
                    } label: {
                        HStack {
                            Image(systemName: app.iconName)
                            Text(app.name)
                            Spacer()
                            if guardedApps.contains(app) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Choose Apps")
        .listStyle(.insetGrouped)
    }
    
    /// Adds an app to the guarded list, showing the paywall if the free limit is reached.
    func addApp(_ app: GuardedApp) {
        // If already added, do nothing
        if guardedApps.contains(app) { return }
        
        // Free limit of 2 apps
        if guardedApps.count >= 2 {
            showingPaywall = true
        } else {
            guardedApps.append(app)
        }
    }
}

/// Guard rules configuration screen.
/// Allows choosing between Always confirm and Smart confirm.
struct GuardRulesView: View {
    enum ConfirmationMode: String, CaseIterable, Identifiable {
        case always = "Always Confirm"
        case smart = "Smart Confirm"
        
        var id: String { rawValue }
    }
    
    @State private var mode: ConfirmationMode = .always
    @State private var recentMinutes: Double = 10
    
    var body: some View {
        Form {
            Section(header: Text("Confirmation Mode")) {
                Picker("", selection: $mode) {
                    ForEach(ConfirmationMode.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                if mode == .smart {
                    HStack {
                        Text("Ask if opened within")
                        Spacer()
                        Text("\(Int(recentMinutes)) min")
                    }
                    Slider(value: $recentMinutes, in: 5...60, step: 5)
                }
            }
            Section(footer: Text("Smart Confirm mode is part of TapGuard Pro.")) {
                // Placeholder for pro upsell or other settings
            }
        }
        .navigationTitle("Guard Rules")
    }
}

/// Paywall screen describing TapGuard Pro benefits.
struct PaywallView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("TapGuard Pro")
                        .font(.largeTitle.bold())
                    Text("Break the autopilot")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        Image(systemName: "infinity")
                            .frame(width: 24)
                        Text("Unlimited guarded apps")
                    }
                    HStack(alignment: .top) {
                        Image(systemName: "lightbulb")
                            .frame(width: 24)
                        Text("Smart Confirm rules")
                    }
                    HStack(alignment: .top) {
                        Image(systemName: "text.bubble")
                            .frame(width: 24)
                        Text("Custom prompts")
                    }
                    HStack(alignment: .top) {
                        Image(systemName: "nosign")
                            .frame(width: 24)
                        Text("No ads")
                    }
                }
                .font(.body)
                
                VStack(spacing: 16) {
                    Button(action: {
                        // handle purchase here
                    }) {
                        Text("Unlock TapGuard Pro")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    Button(action: {
                        // handle continue with free version
                    }) {
                        Text("Continue with Free (2 apps)")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("TapGuard Pro")
    }
}

// Preview provider for Xcode previews
struct TapGuardPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

