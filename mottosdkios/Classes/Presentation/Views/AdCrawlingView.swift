//
//  AdCrawlingView.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit
import SnapKit
import Then
import WebKit

protocol CrawlingFunc {
    func objectFound(code: Int, args: String)
    func objectNotFound(code: Int)
}

class AdCrawlingView: AdBaseView, CrawlingFunc {
    
    var scripts: [String] = []
    let topMarginPt: Double = 27
    var scriptNumber: Int = 0
    var scriptRetryCount: Int  = 0
    var moreSearch: Bool = true
    
    func objectFound(code: Int, args: String) {}
    func objectNotFound(code: Int) {}
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func callScript(number: Int, delay: Int) {
        scriptNumber = number
        let index = number - 1
        Utils.consoleLog("callscript scripts", scripts, true)
        if scripts.count > index {
            let script: String = scripts[index]
            Utils.consoleLog("callscript script[\(index)]", script, true)
            if script.count > 0 {
                loadUrlWithDelay(url: script, delay: delay)
            }
        }
    }
    
    func crawlingClear() {
        moreSearch = true
        scriptNumber = 0
    }
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "MMJS" {
            super.userContentController(userContentController, didReceive: message)
            return
        }
        if message.name == "MMCWJS", let messageBody = message.body as? [String: Any] {
            let messageString = String(describing: messageBody["message"] ?? "")
            let script1 = String(describing: messageBody["script1"] ?? "")
            let script2 = String(describing: messageBody["script2"] ?? "")
            let script3 = String(describing: messageBody["script3"] ?? "")
            let script4 = String(describing: messageBody["script4"] ?? "")
            let script5 = String(describing: messageBody["script5"] ?? "")
            
            let code = String(describing: messageBody["code"] ?? "")
            let args = String(describing: messageBody["args"] ?? "")
            
            switch messageString {
            case "onScripts":
                scripts.removeAll()
                scripts.append(script1)
                scripts.append(script2)
                scripts.append(script3)
                scripts.append(script4)
                scripts.append(script5)
                
            case "onObjectFound":
                let codeInt: Int = Int(code) ?? 0
                let argsDouble: Double = Double(args) ?? 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if codeInt >= 20 && codeInt < 30 {
                        var scrollTop: Double = 0
                        if argsDouble > 0 {
                            scrollTop = argsDouble
                        }

                        let webDensity: Double = UIScreen.main.scale
                        if scrollTop != 0  {
                            let scrollY = self.webView.scrollView.contentOffset.y
                            let tmp = Int(scrollY) / Int(webDensity)

                            scrollTop -= webDensity * self.topMarginPt
                            let scroll = Int(scrollTop) + tmp
                            self.webView.scrollView.setContentOffset(CGPoint(x: 0, y: Int(scroll * Int(webDensity))), animated: true)
                        }

                        self.objectFound(code: codeInt, args: args)
                    } else if codeInt >= 30 && codeInt < 40 {
                        if args.count > 0 {
                            let xy: [String] = args.components(separatedBy: ",")
                            if xy.count > 0 {
//                                let left: Double = Double(xy[0]) ?? 0
//                                let top: Double = Double(xy[1]) ?? 0
//                                let webDensity: Double = UIScreen.main.scale
    //                            let x: Double = webDensity * (left + 20)
    //                            let y: Double = webDensity * (top + 20)
                                
                                // ios X
    //                            autoTouch(x: x, y: y)
                            }
                        }
                    } else {
                        self.objectFound(code: codeInt, args: args)
                    }
                }
                
            case "onObjectNotFound":
                let codeInt: Int = Int(code) ?? 0
                let argsDouble: Double = Double(args) ?? 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if codeInt >= 20 && codeInt < 30 {
                        var canScroll: Bool = false
                        if codeInt == 21 {
                            if self.scriptRetryCount < 5 {
                                self.scriptRetryCount += 1
                                canScroll = true
                            }
                        } else {
                            if self.moreSearch {
                                self.moreSearch = false
                                canScroll = true
                            }
                        }

                        if canScroll {
                            let height: Double = Double(self.webView.frame.height) * 100
                            self.webView.scrollView.setContentOffset(CGPoint(x: 0, y: height), animated: true)
                            let delay = self.delayByPerformance() - 1500
                            self.callScript(number: self.scriptNumber, delay: delay)
                        }
                    }

                    self.objectNotFound(code: codeInt)
                }
            default:
                break
            }
        }
    }
}
