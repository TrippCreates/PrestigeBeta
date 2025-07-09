import SwiftUI
import PhotosUI

// MARK: - Shared Settings Components
struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            Text(title)
                .font(PrestigeTheme.fonts.systemHeadline)
                .foregroundColor(PrestigeTheme.colors.primary)
            
            VStack(spacing: 1) {
                content
            }
            .background(PrestigeTheme.colors.cardBackground)
            .cornerRadius(PrestigeTheme.spacing.cornerRadius)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

struct ToggleSetting: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(PrestigeTheme.fonts.systemBody)
                    .foregroundColor(PrestigeTheme.colors.primary)
                
                Text(subtitle)
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: PrestigeTheme.colors.accent))
        }
        .padding()
        .background(PrestigeTheme.colors.cardBackground)
    }
}

struct SettingRow: View {
    let title: String
    let subtitle: String
    var titleColor: Color = PrestigeTheme.colors.primary
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(PrestigeTheme.fonts.systemBody)
                    .foregroundColor(titleColor)
                
                Text(subtitle)
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(PrestigeTheme.colors.textSecondary)
        }
        .padding()
        .background(PrestigeTheme.colors.cardBackground)
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var selectionLimit: Int = 1
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = selectionLimit
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
} 