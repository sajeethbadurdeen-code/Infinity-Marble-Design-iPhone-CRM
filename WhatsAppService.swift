import Foundation
import UIKit

struct WhatsAppService {
    static func open(project: Project, settings: CRMSettings) {
        guard !project.phone.isEmpty else { return }
        let digits = project.phone.filter { $0.isNumber || $0 == "+" }.replacingOccurrences(of: "+", with: "")
        let lines = [settings.businessName, project.quoteNo.isEmpty ? nil : "Quote \(project.quoteNo)", project.invoiceNo.isEmpty ? nil : "Invoice \(project.invoiceNo)", "Client: \(project.client)", "Scope: \(project.scope)", "Material: \(project.material)", "Amount: \(money(project.value, settings: settings))", "", "\(settings.phone) · \(settings.email)", settings.website].compactMap { $0 }
        let message = lines.joined(separator: "\n")
        guard let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: "https://wa.me/\(digits)?text=\(encoded)") else { return }
        UIApplication.shared.open(url)
    }
}
