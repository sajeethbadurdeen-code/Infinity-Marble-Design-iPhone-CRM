import Foundation
import Observation

enum Stage: String, CaseIterable, Codable, Identifiable {
    case inquiry, quoted, approved, fabrication, installed
    var id: String { rawValue }
    var label: String { rawValue.capitalized }
}

struct Project: Identifiable, Codable, Hashable {
    var id = UUID()
    var client = ""
    var contact = ""
    var phone = ""
    var material = "Calacatta Gold"
    var scope = ""
    var stage: Stage = .inquiry
    var value: Double = 0
    var notes = ""
    var quoteNo = ""
    var invoiceNo = ""
    var updated = Date()
}

struct InventoryItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var collection = ""
    var type = "Marble"
    var slabs = 0
    var sqft = 0.0
    var pricePerSqft = 0.0
    var supplier = ""
}

struct CRMSettings: Codable, Equatable {
    var businessName = "Infinity Marble Design"
    var phone = "+974 55817661"
    var email = "infinitymarbledesign@gmail.com"
    var website = "www.infinitymarbledesign.com"
    var address = "Doha, Qatar"
    var crNumber = "CR.227477"
    var whatsappWebhook = ""
    var currency = "QR "
    var quotePrefix = "QT-"
    var invoicePrefix = "INV-"
}

@Observable final class CRMStore {
    var projects: [Project] = []
    var inventory: [InventoryItem] = []
    var settings = CRMSettings()
    var quoteCounter = 1
    var invoiceCounter = 1

    private let defaults = UserDefaults.standard
    private let projectsKey = "imd.projects"
    private let inventoryKey = "imd.inventory"
    private let settingsKey = "imd.settings"
    private let countersKey = "imd.counters"

    init() { load() }

    func load() {
        projects = decode([Project].self, key: projectsKey) ?? Self.seedProjects
        inventory = decode([InventoryItem].self, key: inventoryKey) ?? Self.seedInventory
        settings = decode(CRMSettings.self, key: settingsKey) ?? CRMSettings()
        if let counters = decode([String: Int].self, key: countersKey) {
            quoteCounter = counters["quote"] ?? 1
            invoiceCounter = counters["invoice"] ?? 1
        }
        saveAll()
    }

    func saveAll() {
        encode(projects, key: projectsKey)
        encode(inventory, key: inventoryKey)
        encode(settings, key: settingsKey)
        encode(["quote": quoteCounter, "invoice": invoiceCounter], key: countersKey)
    }

    func saveProject(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) { projects[index] = project }
        else { projects.append(project) }
        saveAll()
    }

    func deleteProject(_ project: Project) { projects.removeAll { $0.id == project.id }; saveAll() }
    func move(_ project: Project, to stage: Stage) { var p = project; p.stage = stage; p.updated = Date(); saveProject(p) }

    func saveInventory(_ item: InventoryItem) {
        if let index = inventory.firstIndex(where: { $0.id == item.id }) { inventory[index] = item }
        else { inventory.append(item) }
        saveAll()
    }
    func deleteInventory(_ item: InventoryItem) { inventory.removeAll { $0.id == item.id }; saveAll() }

    func assignQuote(to project: Project) -> Project {
        var p = project
        p.quoteNo = "\(settings.quotePrefix)\(String(format: "%04d", quoteCounter))"
        quoteCounter += 1; saveProject(p); saveAll(); return p
    }

    func assignInvoice(to project: Project) -> Project {
        var p = project
        p.invoiceNo = "\(settings.invoicePrefix)\(String(format: "%04d", invoiceCounter))"
        invoiceCounter += 1; saveProject(p); saveAll(); return p
    }

    private func encode<T: Encodable>(_ value: T, key: String) { if let data = try? JSONEncoder().encode(value) { defaults.set(data, forKey: key) } }
    private func decode<T: Decodable>(_ type: T.Type, key: String) -> T? { guard let data = defaults.data(forKey: key) else { return nil }; return try? JSONDecoder().decode(type, from: data) }

    static let seedProjects: [Project] = [
        Project(client: "Whitfield Residence", contact: "Anna Whitfield", material: "Calacatta Gold", scope: "Kitchen island + counters", stage: .quoted, value: 8400),
        Project(client: "Marchetti Kitchens", contact: "Luca Marchetti", material: "Nero Marquina", scope: "Bathroom vanities (x3)", stage: .fabrication, value: 5200),
        Project(client: "Oakview Developers", contact: "Priya Nair", material: "Taj Mahal Quartzite", scope: "Lobby flooring, 400 sqft", stage: .inquiry, value: 22000)
    ]
    static let seedInventory: [InventoryItem] = [
        InventoryItem(collection: "Calacatta Gold", type: "Marble", slabs: 6, sqft: 312, pricePerSqft: 95),
        InventoryItem(collection: "Nero Marquina", type: "Marble", slabs: 4, sqft: 190, pricePerSqft: 78),
        InventoryItem(collection: "Taj Mahal Quartzite", type: "Quartzite", slabs: 3, sqft: 165, pricePerSqft: 110)
    ]
}
