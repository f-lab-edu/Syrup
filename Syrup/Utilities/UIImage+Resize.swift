import UIKit

extension UIImage {
    func resize(to targetSize: CGSize, isOpaque: Bool = false, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        format.opaque = isOpaque
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let resizedImage = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }
}
