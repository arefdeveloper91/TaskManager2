import Foundation
import CoreData
import Combine

class TaskViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var tasks: [Task] = []
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "TaskManager") 
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error.localizedDescription)")
            }
        }
        fetchTasks()
    }
    
    // Buscar tarefas
    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.createAt, ascending: true)]
        
        do {
            tasks = try container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
        }
    }
    
    // Adicionar tarefa
    func addTask() {
        guard !title.isEmpty else { return }
        
        let newTask = Task(context: container.viewContext)
        newTask.title = title
        newTask.isCompleted = false
        newTask.createAt = Date()
        
        save()
        title = "" // limpa o campo
    }
    
    // Alternar concluído/não concluído
    func toggleCompletion(task: Task) {
        task.isCompleted.toggle()
        save()
    }
    
    // Deletar tarefa
    func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = tasks[index]
            container.viewContext.delete(task)
        }
        save()
    }
    
    // Salvar mudanças no Core Data
    private func save() {
        do {
            try container.viewContext.save()
            fetchTasks() // recarrega lista
        } catch {
            print("Error saving Core Data: \(error.localizedDescription)")
        }
    }
}

