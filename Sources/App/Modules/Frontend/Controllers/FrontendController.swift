import Foundation
import Vapor

struct FrontendController {
    
    func homeView(req: Request) throws -> EventLoopFuture<View> {
        var email: String?
        if let user = req.auth.get(UserModel.self) {
            email = user.email
        }
        struct Context: Encodable {
            let title: String
            let header: String
            let message: String
            let email: String?
        }
        let context = Context(title: "Valorant Setups - Home",
                              header: "Hi there,",
                              message: "Sign in to add and edit lineups",
                              email: email)
        return req.view.render("Frontend/Home", context)
    }
}
