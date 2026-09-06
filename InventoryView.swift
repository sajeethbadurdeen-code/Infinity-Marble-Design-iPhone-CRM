import SwiftUI

struct InventoryView: View {
    @Environment(CRMStore.self) private var store
    @Binding var showingNewInventory: Bool
    @State private var selected: InventoryItem?
    var body: some View {
        List {
            Section { ForEach(store.inventory) { item in Button { selected = item } label: { InventoryRow(item: item) }.buttonStyle(.plain).swipeActions { Button(role: .destructive) { store.deleteInventory(item) } label: { Label("Delete", systemImage: "trash") } } } }
        }
        .scrollContentBackground(.hidden).background(IMDTheme.ground)
        .navigationTitle("Inventory")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { Button { showingNewInventory = true } label: { Image(systemName: "plus") } } }
        .sheet(item: $selected) { InventoryEditor(item: $0) }
    }
}

struct InventoryRow: View {
    @Environment(CRMStore.self) private var store
    let item: InventoryItem
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) { Text(item.collection).font(.headline); Text("\(item.type) · \(item.slabs) slabs · \(item.sqft.formatted(.number.precision(.fractionLength(0)))) sqft").font(.caption).foregroundStyle(IMDTheme.inkSoft) }
            Spacer(); Text(money(item.pricePerSqft, settings: store.settings) + "/sqft").font(.caption.weight(.medium)).foregroundStyle(IMDTheme.brassDeep)
        }.padding(.vertical, 7)
    }
}
