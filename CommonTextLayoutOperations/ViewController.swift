//
//  ViewController.swift
//  CommonTextLayoutOperations
//
//  Created by 何柱君 on 2022/5/15.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    let label21 = UILabel()
    let view21 = Listing21View()
    
    let label22 = UILabel()
    let view22 = Listing22View()
    
    let label24 = UILabel()
    let view24 = Listing24View()
    
    let label25 = UILabel()
    let view25 = Listing25View()
    
    let label27 = UILabel()
    let view27 = Listing27View()
    
    let label28 = UILabel()
    let view28 = Listing28View()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view)
        }
        
        label21.text = "Listing 2-1"
        addListingView(label: label21, listingView: view21, topView: nil, isEnd: false)
        
        label22.text = "Listing 2-2"
        addListingView(label: label22, listingView: view22, topView: view21, isEnd: false)
        
        label24.text = "Listing 2-4"
        addListingView(label: label24, listingView: view24, topView: view22, isEnd: false)
        
        label25.text = "Listing 2-5"
        addListingView(label: label25, listingView: view25, topView: view24, isEnd: false)
        
        label27.text = "Listing 2-7"
        addListingView(label: label27, listingView: view27, topView: view25, isEnd: false)
        
        label28.text = "Listing 2-8"
        addListingView(label: label28, listingView: view28, topView: view27, isEnd: true)
    }
    
    func addListingView(label: UILabel, listingView: UIView, topView: UIView?, isEnd: Bool) {
        scrollView.addSubview(label)
        scrollView.addSubview(listingView)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(topView == nil ? scrollView : topView!.snp.bottom)
        }
        listingView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(label.snp.bottom)
            make.height.equalTo(100)
            if isEnd {
                make.bottom.equalToSuperview()
            }
        }
    }
}

extension ViewController {
    // MARK: Listing 2 - 1
    class Listing21View: UIView {
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.textMatrix = CGAffineTransform.identity
            let path = CGMutablePath()
            path.addRect(rect)
            let textString = "Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."
            let attrString = NSMutableAttributedString(string: textString, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .regular), .backgroundColor: UIColor.white.cgColor])
            attrString.setAttributes([.foregroundColor: UIColor.red.withAlphaComponent(0.8).cgColor], range: NSRange(location: 0, length: 12))
            
            // 生成 framesetter
            let framesetter = CTFramesetterCreateWithAttributedString(attrString)
            // 生成一帧
            let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)
            // 绘制
            CTFrameDraw(frame, context)
        }
    }
    
    // MARK: Listing 2 - 2
    class Listing22View: UIView {
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.textMatrix = CGAffineTransform.identity
            
            let string = "Hello, World!"
            let font = UIFont.systemFont(ofSize: 15, weight: .regular)
            let attrString = NSAttributedString(string: string, attributes: [.font: font, .foregroundColor: UIColor.white.cgColor])
            
            let line = CTLineCreateWithAttributedString(attrString)
            context.textPosition = CGPoint(x: 0, y: 0)
            CTLineDraw(line, context)
        }
    }
    
    class Listing24View: UIView {
        
        // MARK: Listing 2 - 3
        func createColumns(with columnCount: Int, rect: CGRect) -> [CGPath] {
            var columnrect = [CGRect]()
            let columnWith = rect.width / CGFloat(columnCount)
            for i in 0..<columnCount {
                let x = rect.minX + columnWith * CGFloat(i)
                let y = rect.minY
                let width = min(columnWith, rect.width - x)
                let height = rect.height
                columnrect.append(CGRect(x: x, y: y, width: width, height: height))
            }
            // 增加内边距
            for i in 0..<columnrect.count {
                columnrect[i] = columnrect[i].insetBy(dx: 8, dy: 15)
            }
            
            let paths = columnrect.map { rect in
                CGPath(rect: rect, transform: nil)
            }
            
            return paths
        }
        
        // MARK: Listing 2 - 4
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.textMatrix = CGAffineTransform.identity
            
            let textString = "Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."
            let attrString = NSMutableAttributedString(
                string: textString,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                    .foregroundColor: UIColor.white.cgColor
                ]
            )
            let framesetter = CTFramesetterCreateWithAttributedString(attrString)
            let columnPaths = createColumns(with: 3, rect: rect)
            let pathCount = columnPaths.count
            var startIndex: CFIndex = 0
            for column in 0..<pathCount {
                let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: startIndex, length: 0), columnPaths[column], nil)
                CTFrameDraw(frame, context)
                
                let frameRange = CTFrameGetVisibleStringRange(frame)
                startIndex += frameRange.length
            }
        }
    }
    
    // MARK: Listing 2 - 5
    class Listing25View: UIView {
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.textMatrix = CGAffineTransform.identity
            
            let textString = "Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."
            let attrString = NSMutableAttributedString(
                string: textString,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 19, weight: .regular),
                    .foregroundColor: UIColor.white.cgColor
                ]
            )
            
            let typesetter = CTTypesetterCreateWithAttributedString(attrString)
            var start: CFIndex = 0;
            // 给定展示长度，找到换行的位置
            let count = CTTypesetterSuggestLineBreak(typesetter, start, rect.width)
            let line = CTTypesetterCreateLine(typesetter, CFRange(location: start, length: count))
            
            // 居中的偏移量
            let flush: CGFloat = 0.5
            let penOffset = CTLineGetPenOffsetForFlush(line, flush, rect.width)
            context.textPosition = CGPoint(x: context.textPosition.x + penOffset, y: context.textPosition.y)
            CTLineDraw(line, context)
            
            start += count
        }
    }
    
    class Listing27View: UIView {
        
        enum ViewError: Error {
            case FontNotFound
        }
        
        // MARK: Listing 2 - 6
        func applyParaSyle(fontName: String, pointSize: CGFloat, plainText: String, lineSpaceInc: CGFloat) throws -> NSAttributedString {
            let font = UIFont(name: fontName, size: pointSize)
            if font == nil {
                throw ViewError.FontNotFound
            }
            var lineSpacing = (CTFontGetLeading(font!) + lineSpaceInc) * 2
            
            var setting = CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing)
            let paragraphStyle = CTParagraphStyleCreate(&setting, 1)
            
            let attrString = NSAttributedString(string: plainText, attributes: [.font: font!, .paragraphStyle: paragraphStyle, .foregroundColor: UIColor.white.cgColor])
            return attrString
        }
        
        // MARK: Listing 2 - 7
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.textMatrix = CGAffineTransform.identity
            
            let fontName = "Didot Italic"
            let pointSize: CGFloat = 24
            let string = "Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."
            do {
                let attrString = try applyParaSyle(fontName: fontName, pointSize: pointSize, plainText: string, lineSpaceInc: 10)
                let framesetter = CTFramesetterCreateWithAttributedString(attrString)
                let path = CGPath(rect: rect, transform: nil)
                let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)
                CTFrameDraw(frame, context)
            } catch {
                print(error)
            }
        }
    }
    
    class Listing28View: UIView {
        
        var path: CGMutablePath {
            let path = CGMutablePath()
            var bounds = self.bounds
            bounds = bounds.insetBy(dx: 10, dy: 10)
            addSquashedDonutPath(path: path, rect: bounds)
            return path
        }
        
        func addSquashedDonutPath(path: CGMutablePath, transform: CGAffineTransform = .identity, rect: CGRect) {
            let width = rect.width
            let height = rect.height
            
            let radiusH = width / 3.0
            let radiusV = height / 3.0
            
            path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y + height - radiusV), transform: transform)
            path.addQuadCurve(to: CGPoint(x: rect.origin.x, y: rect.origin.y + height), control: CGPoint(x: rect.origin.x + radiusH, y: rect.origin.y + height), transform: transform)
            path.addLine(to: CGPoint(x: rect.origin.x + width - radiusH, y: rect.origin.y + height), transform: transform)
            path.addQuadCurve(to: CGPoint(x: rect.origin.x + width, y: rect.origin.y + height), control: CGPoint(x: rect.origin.x + width, y: rect.origin.y + height - radiusV), transform: transform)
            path.addLine(to: CGPoint(x: rect.origin.x + width, y: rect.origin.y + radiusV), transform: transform)
            path.addQuadCurve(to: CGPoint(x: rect.origin.x + width, y: rect.origin.y), control: CGPoint(x: rect.origin.x + width - radiusH, y: rect.origin.y), transform: transform)
            path.addLine(to: CGPoint(x: rect.origin.x + radiusH, y: rect.origin.y), transform: transform)
            path.addQuadCurve(to: CGPoint(x: rect.origin.x, y: rect.origin.y), control: CGPoint(x: rect.origin.x, y: rect.origin.y + radiusV), transform: transform)
            path.closeSubpath()
            path.addEllipse(in: CGRect(x: rect.origin.x + width / 2 - width / 5, y: rect.origin.y + height / 2 - height / 5, width: width / 5 * 2, height: height / 5 * 2), transform: transform)
        }
        
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.translateBy(x: 0, y: rect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.textMatrix = CGAffineTransform.identity
            
            let textString = "Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine."
            let attrString = NSMutableAttributedString(
                string: textString,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                    .foregroundColor: UIColor.blue.cgColor
                ]
            )
            let framesetter = CTFramesetterCreateWithAttributedString(attrString)
            
            var startIndex = 0
            
            context.setFillColor(UIColor.yellow.cgColor)
            context.addPath(path)
            context.fillPath()
            
            let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: startIndex, length: 0), path, nil)
            CTFrameDraw(frame, context)
        }
    }
}
