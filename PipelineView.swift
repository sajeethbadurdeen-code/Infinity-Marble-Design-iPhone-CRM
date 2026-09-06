import SwiftUI

struct PipelineView: View {
    @Environment(CRMStore.self) private var store
    @Binding var selectedProject: Project?
    @Binding var showingNewProject: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AppHeader()
                HStack(spacing: 8) {
                    StatCard(title: "Active Projects", value: "\(store.projects.filter { $0.stage != .installed }.count)")
                    StatCard(title: "Pipeline Value", value: money(store.projects.reduce(0) { $0 + $1.value }, settings: store.settings), accent: IMDTheme.brassDeep)
                }
                HStack(spacing: 8) {
                    StatCard(title: "Installed", value: "\(store.projects.filter { $0.stage == .installed }.count)", accent: IMDTheme.verdigris)
                    StatCard(title: "Low Stock", value: "\(store.inventory.filter { $0.sqft < 50 }.count)", accent: IMDTheme.rose)
                }
                HStack { Text("Pipeline").font(.headline); Spacer(); Button("+ New Project") { showingNewProject = true }.buttonStyle(.borderedProminent).tint(IMDTheme.brass) }
                ForEach(Stage.allCases) { stage in
                    let items = store.projects.filter { $0.stage == stage }
                    VStack(alignment: .leading, spacing: 8) {
                        HStack { Circle().fill(stageColor(stage)).frame(width: 8, height: 8); Text(stage.label.uppercased()).font(.caption.weight(.semibold)); Text("\(items.count)").font(.caption).foregroundStyle(IMDTheme.inkSoft) }
                        if items.isEmpty { Text("Empty").font(.caption).italic().foregroundStyle(IMDTheme.inkSoft).padding(.leading, 4) }
                        ForEach(items) { project in ProjectCard(project: project) { selectedProject = project } }
                    }
                    .padding(12).background(IMDTheme.panel.opacity(0.72)).clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }.padding(.horizontal, 16).padding(.bottom, 30)
        }
        .background(IMDTheme.ground)
        .navigationTitle("Infinity Marble")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func stageColor(_ stage: Stage) -> Color { switch stage { case .inquiry: IMDTheme.inkSoft; case .quoted: IMDTheme.brass; case .approved: IMDTheme.verdigris; case .fabrication: IMDTheme.rose; case .installed: Color(red: 0.23, green: 0.35, blue: 0.25) } }
}

struct ProjectCard: View {
    @Environment(CRMStore.self) private var store
    let project: Project; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                HStack { Text(project.client).font(.subheadline.weight(.semibold)); Spacer(); Text(money(project.value, settings: store.settings)).font(.caption).foregroundStyle(IMDTheme.inkSoft) }
                Text(project.scope).font(.caption).foregroundStyle(IMDTheme.inkSoft).frame(maxWidth: .infinity, alignment: .leading)
                HStack { Text(project.material).font(.caption.weight(.medium)).foregroundStyle(IMDTheme.brassDeep); Spacer(); if !project.quoteNo.isEmpty { Text(project.quoteNo).font(.caption2) } }
                ScrollView(.horizontal, showsIndicators: false) { HStack { ForEach(Stage.allCases.filter { $0 != project.stage }) { stage in Button("→ \(stage.label)") { store.move(project, to: stage) }.font(.caption2).buttonStyle(.bordered).tint(IMDTheme.inkSoft) }; WhatsAppButton(project: project) } }
            }.padding(12).background(IMDTheme.panel).clipShape(RoundedRectangle(cornerRadius: 8)).overlay(RoundedRectangle(cornerRadius: 8).stroke(IMDTheme.line))
        }.buttonStyle(.plain)
    }
}

struct WhatsAppButton: View {
    @Environment(CRMStore.self) private var store
    let project: Project
    var body: some View {
        Button { WhatsAppService.open(project: project, settings: store.settings) } label: { Label("WhatsApp", systemImage: "message.fill") }.font(.caption2.weight(.semibold)).buttonStyle(.bordered).tint(IMDTheme.whatsapp)
    }
}
