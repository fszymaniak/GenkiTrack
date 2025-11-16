import SwiftUI

struct ChatView: View {
    @StateObject private var chatManager = ChatManager()
    @State private var messageText = ""
    @State private var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(chatManager.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                        .onAppear {
                            scrollProxy = proxy
                            scrollToBottom()
                        }
                        .onChange(of: chatManager.messages.count) { _ in
                            scrollToBottom()
                        }
                    }
                }
                
                // Message input
                HStack(spacing: 10) {
                    TextField("Napisz wiadomość...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 30)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.green))
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
            }
            .navigationTitle("Czat z dietetykiem")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        chatManager.sendMessage(messageText)
        messageText = ""
        scrollToBottom()
    }
    
    func scrollToBottom() {
        guard let lastMessage = chatManager.messages.last else { return }
        withAnimation {
            scrollProxy?.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 5) {
                Text(message.text)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(message.isUser ? Color.green : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? .white : .black)
                    .cornerRadius(20)
                    .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
                
                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if !message.isUser { Spacer() }
        }
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
