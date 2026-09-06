import SwiftUI

struct ProjectEditor: View {
    @Environment(CRMStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var form: Project
    @State private var showDelete = false
    init(project: Project) { _form = State(initialValue: project) }

    var body: some View {
        NavigationStack {
            Form {
                Section("Client") { TextField("Client", text: $form.client); TextField("Contact", text: $form.contact); TextField("Phone", text: $form.phone); TextField("Scope", text: $form.scope, axis: .vertical) }
                Section("Project") { TextField("Material", text: $form.material); Picker("Stage", selection: $form.stage) { ForEach(Stage.allCases) { Text($0.label).tag($0) } }; TextField("Value", value: $form.value, format: .number).keyboardType(.decimalPad); TextField("Notes", text: $form.notes, axis: .vertical) }
                Section("Documents") {
                    HStack { Text("Quote"); Spacer(); if form.quoteNo.isEmpty { Button("Assign") { form = store.assignQuote(to: form) } } else { Text(form.quoteNo) } }
                    HStack { Text("Invoice"); Spacer(); if form.invoiceNo.isEmpty { Button("Assign") { form = store.assignInvoice(to: form) } } else { Text(form.invoiceNo) } }
                    Button { WhatsAppService.open(project: form, settings: store.settings) } label: { Label("Send via WhatsApp", systemImage: "message.fill") }.foregroundStyle(IMDTheme.whatsapp)
                }
                if form.id != Project().id { Section { Button("Delete Project", role: .destructive) { showDelete = true } } }
            }
            .navigationTitle(form.client.isEmpty ? "New Project" : "Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Save") { form.updated = Date(); store.saveProject(form); dismiss() } } }
            .confirmationDialog("Delete this project?", isPresented: $showDelete) { Button("Delete", role: .destructive) { store.deleteProject(form); dismiss() } }
        }
    }
}

struct InventoryEditor: View {
    @Environment(CRMStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var form: InventoryItem
    init(item: InventoryItem) { _form = State(initialValue: item) }
    var body: some View {
        NavigationStack { Form {
            Section("Collection") { TextField("Collection", text: $form.collection); TextField("Type", text: $form.type); TextField("Supplier", text: $form.supplier) }
            Section("Stock") { TextField("Slabs", value: $form.slabs, format: .number).keyboardType(.numberPad); TextField("Square feet", value: $form.sqft, format: .number).keyboardType(.decimalPad); TextField("Price / sqft", value: $form.pricePerSqft, format: .number).keyboardType(.decimalPad) }
        }.navigationTitle("Collection").toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Save") { store.saveInventory(form); dismiss() } } } }
    }
}

struct SettingsView: View {
    @Environment(CRMStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var form = CRMSettings()
    var body: some View {
        NavigationStack { Form {
            Section("Business") { TextField("Business name", text: $form.businessName); TextField("Phone", text: $form.phone); TextField("Email", text: $form.email); TextField("Website", text: $form.website); TextField("Address", text: $form.address); TextField("CR number", text: $form.crNumber) }
            Section("Documents") { TextField("Currency", text: $form.currency); TextField("Quote prefix", text: $form.quotePrefix); TextField("Invoice prefix", text: $form.invoicePrefix) }
            Section("WhatsApp") { TextField("Webhook URL", text: $form.whatsappWebhook, axis: .vertical); Text("The iPhone app can open WhatsApp directly. A webhook can be connected later to your n8n/WhatsApp Business flow.").font(.caption).foregroundStyle(IMDTheme.inkSoft) }
        }.navigationTitle("Settings").onAppear { form = store.settings }.toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }; ToolbarItem(placement: .confirmationAction) { Button("Save") { store.settings = form; store.saveAll(); dismiss() } } } }
    }
}
