//
//  AppleAccountView.swift
//  Preferences
//
//  Local demo Apple Account / iCloud screens. These screens do not authenticate
//  with Apple or access a real iCloud account.
//

import SwiftUI

struct AppleAccountView: View {
    private let path = "/System/Library/PrivateFrameworks/AppleAccountUI.framework"

    var body: some View {
        CustomList(title: "APPLE_ID_REBRAND".localized(path: path)) {
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 92))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .gray.gradient)
                Text("88")
                    .font(.system(size: 32, weight: .semibold))
                Text("amamamam9777@icloud.com")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                Text("Демонстрационный аккаунт")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .listRowBackground(Color.clear)

            Section {
                SLink("Личная информация", icon: "person.text.rectangle.fill") {
                    DemoAccountDetailView(title: "Личная информация", symbol: "person.text.rectangle.fill")
                }
                SLink("Вход и безопасность", icon: "key.fill") {
                    DemoAccountDetailView(title: "Вход и безопасность", symbol: "key.fill")
                }
                SLink("Оплата и доставка", icon: "creditcard.fill") {
                    DemoAccountDetailView(title: "Оплата и доставка", symbol: "creditcard.fill")
                }
                SLink("Подписки", icon: "arrow.clockwise.circle.fill") {
                    DemoAccountDetailView(title: "Подписки", symbol: "arrow.clockwise.circle.fill")
                }
            }

            Section {
                SLink("iCloud", icon: "iCloud", status: "5 ГБ") {
                    DemoICloudView()
                }
                SLink("Семья", icon: "person.2.fill", status: "Настроить") {
                    DemoAccountDetailView(title: "Семья", symbol: "person.2.fill")
                }
                SLink("Локатор", icon: "location.fill") {
                    DemoAccountDetailView(title: "Локатор", symbol: "location.fill")
                }
                SLink("Контент и покупки", icon: "appstore.fill") {
                    DemoAccountDetailView(title: "Контент и покупки", symbol: "appstore.fill")
                }
                SLink("Вход с Apple", icon: "apple.logo") {
                    DemoAccountDetailView(title: "Вход с Apple", symbol: "apple.logo")
                }
            }

            Section {
                Text("Это демонстрационный интерфейс. Вход в настоящий Apple ID не выполняется.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct DemoICloudView: View {
    @State private var photos = true
    @State private var drive = true
    @State private var passwords = true
    @State private var notes = true
    @State private var messages = false
    @State private var mail = false

    var body: some View {
        CustomList(title: "iCloud") {
            Section {
                HStack(spacing: 14) {
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(.blue)
                        .frame(width: 48)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Хранилище iCloud")
                            .font(.headline)
                        Text("Использовано 1,2 ГБ из 5 ГБ")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.gray.opacity(0.22))
                                Capsule().fill(Color.blue).frame(width: geometry.size.width * 0.24)
                            }
                        }
                        .frame(height: 7)
                    }
                }
                .padding(.vertical, 8)
                SLink("Управлять хранилищем", icon: "externaldrive.fill") {
                    DemoAccountDetailView(title: "Хранилище iCloud", symbol: "externaldrive.fill")
                }
                SLink("Изменить тарифный план", icon: "plus.circle.fill") {
                    DemoAccountDetailView(title: "Тарифный план iCloud+", symbol: "plus.circle.fill")
                }
            }

            Section("Сохранено в iCloud") {
                Toggle(isOn: $photos) { Label("Фото", systemImage: "photo.fill") }
                Toggle(isOn: $drive) { Label("iCloud Drive", systemImage: "folder.fill") }
                Toggle(isOn: $passwords) { Label("Пароли и связка ключей", systemImage: "key.horizontal.fill") }
                Toggle(isOn: $notes) { Label("Заметки", systemImage: "note.text") }
                Toggle(isOn: $messages) { Label("Сообщения в iCloud", systemImage: "message.fill") }
                Toggle(isOn: $mail) { Label("Почта iCloud", systemImage: "envelope.fill") }
            }

            Section {
                Text("Настройки на этом экране демонстрационные и не изменяют данные настоящего iCloud.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct DemoAccountDetailView: View {
    let title: String
    let symbol: String

    var body: some View {
        CustomList(title: title) {
            Section {
                Label(title, systemImage: symbol)
                Text("Демонстрационный экран — функция не подключена к сервисам Apple.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack { AppleAccountView() }
}
