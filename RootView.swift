import SwiftUI

struct RootView: View {
    @Environment(CRMStore.self) private var store
    @State private var tab: Tab = .pipeline
    @State private var selectedProject: Project?
    @State private var showingNewProject = false
    @State private var showingNewInventory = false
    @State private var showingSettings = false

    enum Tab: Hashable { case pipeline, clients, inventory }

    var body: some View {
        TabView(selection: $tab) {
            NavigationStack { PipelineView(selectedProject: $selectedProject, showingNewProject: $showingNewProject) }
                .tabItem { Label("Pipeline", systemImage: "rectangle.3.group") }.tag(Tab.pipeline)
            NavigationStack { ClientsView(selectedProject: $selectedProject) }
                .tabItem { Label("Clients", systemImage: "person.2") }.tag(Tab.clients)
            NavigationStack { InventoryView(showingNewInventory: $showingNewInventory) }
                .tabItem { Label("Inventory", systemImage: "square.stack.3d.up") }.tag(Tab.inventory)
        }
        .tint(IMDTheme.brassDeep)
        .sheet(item: $selectedProject) { project in ProjectEditor(project: project) }
        .sheet(isPresented: $showingNewProject) { ProjectEditor(project: Project()) }
        .sheet(isPresented: $showingNewInventory) { InventoryEditor(item: InventoryItem()) }
        .sheet(isPresented: $showingSettings) { SettingsView() }
        .toolbarBackground(IMDTheme.ground, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingSettings = true } label: { Image(systemName: "gearshape") }
            }
        }
        .background(IMDTheme.ground)
    }
}

struct AppHeader: View {
    @Environment(CRMStore.self) private var store
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(store.settings.businessName.uppercased()).font(.caption2.weight(.semibold)).tracking(2).foregroundStyle(IMDTheme.brassDeep)
            Text("Project Workspace").font(.system(.title2, design: .serif).weight(.semibold)).foregroundStyle(IMDTheme.ink)
            Text("\(store.settings.address) · \(store.settings.phone) · \(store.settings.crNumber)").font(.caption2).foregroundStyle(IMDTheme.inkSoft)
            VeinDivider()
        }
        .padding(.top, 8)
    }
}

struct StatCard: View {
    let title: String; let value: String; var accent: Color = IMDTheme.ink
    var body: some View { VStack(alignment: .leading, spacing: 5) { Text(title.uppercased()).font(.caption2.weight(.medium)).tracking(1).foregroundStyle(IMDTheme.inkSoft); Text(value).font(.system(.title2, design: .serif).weight(.semibold)).foregroundStyle(accent) }.frame(maxWidth: .infinity, alignment: .leading).padding(14).background(IMDTheme.panel).overlay(RoundedRectangle(cornerRadius: 8).stroke(IMDTheme.line)) }
}

func money(_ value: Double, settings: CRMSettings) -> String { "\(settings.currency)\(value.formatted(.number.precision(.fractionLength(0))))" }
