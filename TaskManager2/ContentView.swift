import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                
                HStack {
                    TextField("Enter new task...", text: $viewModel.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 8)
                    
                    Button(action: viewModel.addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.blue, .white)
                            .shadow(radius: 4)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                
                // Lista de tarefas
                if viewModel.tasks.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "checklist")
                            .font(.system(size: 48))
                            .foregroundColor(.gray.opacity(0.6))
                        Text("No tasks yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Add your first task above ✨")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.tasks) { task in
                            HStack {
                                Button {
                                    withAnimation {
                                        viewModel.toggleCompletion(task: task)
                                    }
                                } label: {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isCompleted ? .green : .gray)
                                        .font(.system(size: 22))
                                }
                                .buttonStyle(.plain)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.title ?? "")
                                        .font(.headline)
                                        .foregroundColor(task.isCompleted ? .gray : .primary)
                                        .strikethrough(task.isCompleted, color: .gray)
                                    
                                    if let date = task.createAt {
                                        Text(date, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.vertical, 6)
                        }
                        .onDelete(perform: viewModel.deleteTask)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Task Manager ✅")
        }
    }
}

#Preview {
    ContentView()
}

