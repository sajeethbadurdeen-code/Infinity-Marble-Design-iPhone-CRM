import SwiftUI

struct ClientsView: View {
    @Environment(CRMStore.self) private var store
    @Binding var selectedProject: Project?
    var body: some View {
        List {
            Section { ForEach(store.projects) { project in Button { selectedProject = project } label: { ClientRow(project: project) }.buttonStyle(.plain) } }
        }
        .scrollContentBackground(.hidden).background(IMDTheme.ground).navigationTitle("Clients")
    }
}

struct ClientRow: View {
    @Environment(CRMStore.self) private var store
    let project: Project
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack { Text(project.client).font(.headline); Spacer(); Text(money(project.value, settings: store.settings)).font(.subheadline).foregroundStyle(IMDTheme.brassDeep) }
            Text(project.contact).font(.caption).foregroundStyle(IMDTheme.inkSoft)
            Text("\(project.material) · \(project.stage.label)").font(.caption).foregroundStyle(IMDTheme.inkSoft)
        }.padding(.vertical, 6)
    }
}
