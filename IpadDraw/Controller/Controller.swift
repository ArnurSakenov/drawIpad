//
//  ViewController.swift
//  IpadDraw
//
//  Created by Arnur Sakenov on 08.02.2023.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    var path: UIBezierPath!
   
    var figures: Figures!
    var figur: [DemoView] = []
    var demoView: DemoView!
   let canvas = DemoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rectangle)
        view.addSubview(triangle)
        view.addSubview(canvas)
        view.addSubview(undoButton)
        view.addSubview(circle)
        view.addSubview(draw)
        view.addSubview(line)
        view.addSubview(fillMode)
        view.addSubview(strokeWidthSlider)
        view.addSubview(yellowButton)
        view.addSubview(redButton)
        view.addSubview(blueButton)
        
        rectangle.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.left.equalTo(view.snp.left).offset(20.0)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        triangle.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.left.equalTo(rectangle.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        canvas.snp.makeConstraints { make in
            make.top.equalTo(triangle.snp.bottom).offset(20)
            make.right.equalTo(view.snp.right)
            make.left.equalTo(view.snp.left)
            make.bottom.equalTo(view.snp.bottom)
        }
        circle.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.left.equalTo(triangle.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        line.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.left.equalTo(circle.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        draw.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.left.equalTo(line.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        fillMode.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(35)
            make.left.equalTo(draw.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        strokeWidthSlider.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(35)
            make.left.equalTo(fillMode.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        yellowButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(35)
            make.left.equalTo(strokeWidthSlider.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        blueButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(35)
            make.left.equalTo(yellowButton.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        redButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(35)
            make.left.equalTo(blueButton.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        undoButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.left.equalTo(redButton.snp.right).offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.rectangleTapped))
                        rectangle.addGestureRecognizer(tapGR)
                        rectangle.isUserInteractionEnabled = true
        let tapTraingle = UITapGestureRecognizer(target: self, action: #selector(self.triangleTapped))
            triangle.addGestureRecognizer(tapTraingle)
            triangle.isUserInteractionEnabled = true
        let tapPencil = UITapGestureRecognizer(target: self, action: #selector(self.pencilTapped))
            draw.addGestureRecognizer(tapPencil)
        draw.isUserInteractionEnabled = true
        
        let tapMainView = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnView))
        view.addGestureRecognizer(tapMainView)
        
       
        // Do any additional setup after loading the view.
    }
 
    

    
   
    @objc private func rectangleTapped(){
        canvas.currentMode = .rectangle
       
    }
    
    @objc private func triangleTapped(){
        canvas.currentMode = .triangle
      
    }
    @objc fileprivate func handleColorChange(button: UIButton) {
        canvas.setStrokeColor(color: button.backgroundColor ?? .red)
    }
    
    @objc private func circleTapped() {
        canvas.currentMode = .circle
    
        
    }
    @objc private func pencilTapped() {
        canvas.currentMode = .freeDraw
    }
    
    @objc private func lineTapped() {
        canvas.currentMode = .line
    }
    @objc fileprivate func handleSliderChange() {
        canvas.setStrokeWidth(width: strokeWidthSlider.value)
    }
    @objc private func tappedOnView(_ gesture: UIPanGestureRecognizer){
    }
    @objc func handleSwitchAction(sender: UISwitch){
            
            
            if sender.isOn {
                canvas.fillMode = true
                
                
            }
            else{
                canvas.fillMode = false
            }
        }
  
    @objc fileprivate func handleUndo() {
        print("Undo lines drawn")
        
        canvas.undo()
    }
    
//    @objc private func panned(_ gesture: UIPanGestureRecognizer){
//        let translation = gesture.translation(in: canvas)
//        canvas.frame.origin.x += translation.x
//        canvas.frame.origin.y += translation.y
//        print("moving on location \(translation.x)\(translation.y)")
//        gesture.setTranslation(.zero, in: canvas)
//    }
    private let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
        return button
    }()
    private let rectangle: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "rectangle"), for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(rectangleTapped), for: .touchUpInside)
        return button
    }()
    private let triangle: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "triangle"), for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(triangleTapped), for: .touchUpInside)
        return button
    }()
    private let circle: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(circleTapped), for: .touchUpInside)
        return button
    }()
    private let draw: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(pencilTapped), for: .touchUpInside)
        return button
    }()
    private let line: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.to.line.alt"), for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(lineTapped), for: .touchUpInside)
        return button
    }()
    private let fillMode: UISwitch = {
        let SwitchControl = UISwitch()
                SwitchControl.isOn = false
                SwitchControl.isEnabled = true
                SwitchControl.onTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
                SwitchControl.translatesAutoresizingMaskIntoConstraints = false
                SwitchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
                SwitchControl.isUserInteractionEnabled = true
        return SwitchControl
        
    }()
    private let strokeWidthSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    private let yellowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .yellow
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    private let redButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    private let blueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
//    private let rectangle: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 8
//        imageView.clipsToBounds = true
//        imageView.layer.borderWidth = 1
//        imageView.isUserInteractionEnabled = true
//
//        return imageView
//    }()
//    private let triangle: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 8
//        imageView.clipsToBounds = true
//        imageView.layer.borderWidth = 1
//        imageView.isUserInteractionEnabled = true
//
//        return imageView
//    }()
    
  
}


