import SwiftUI
import ProfileInterface
import SessionInterface
import SearchInterface
import Navigation
import DesignComponents
import DesignTokens
import SharedKernel

package struct ProfileScreen: View {
    @Environment(Router.self) private var router
    private let userID: User.ID
    private let session: any SessionStore

    package init(userID: User.ID, session: any SessionStore) {
        self.userID = userID
        self.session = session
    }

    package var body: some View {
        ScrollView {
            VStack(spacing: Spacing.l) {
                SectionCard {
                    Text("Пользователь \(userID)").font(Typography.title)
                    LabeledRow(title: "На площадке", value: "с 2019 года")
                    LabeledRow(title: "Рейтинг", value: "4.8")
                }

                // Объявления пользователя — это поисковый запрос,
                // а не экран вертикали: у него бывают и товары, и авто.
                // Поэтому Identity ни про Goods, ни про Auto не знает.
                Button {
                    router.push(SearchRoute.sellerListings(userID))
                } label: {
                    SectionCard {
                        HStack {
                            Text("Объявления пользователя").font(Typography.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Palette.secondaryText)
                        }
                    }
                }
                .buttonStyle(.plain)

                SectionCard {
                    Button("Настройки") { router.push(ProfileRoute.settings) }
                }
            }
            .padding(Spacing.l)
        }
        .navigationTitle("Профиль")
    }
}

struct SettingsScreen: View {
    private let session: any SessionStore

    init(session: any SessionStore) {
        self.session = session
    }

    var body: some View {
        List {
            Section {
                LabeledRow(title: "Уведомления", value: "Включены")
                LabeledRow(title: "Язык", value: "Русский")
            }
            Section {
                // Кнопка «Выйти» дёргает SessionStore из SessionInterface.
                // Именно тут обычно тянут `import Auth` и рушат схему:
                // логаут — это состояние сессии, а не фича авторизации.
                Button("Выйти", role: .destructive) { session.signOut() }
            }
        }
        .navigationTitle("Настройки")
    }
}
