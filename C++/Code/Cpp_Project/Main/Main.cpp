#include "../Stack/Stack.h"
#include "../Exception/Exception.h"
#include "../Worker/Worker.h"
#include <string>
#include <iostream>

void printWorker(Worker * worker)
{
    std::cout << worker->getName() << "    " << worker->getSurname() << "   " << worker->getAge();
    std::cout << "    " << worker->getSalary() << "    " << worker->getRank() << "\n";
}

int main()
{
    try
    {
        Worker * workers [] = { new Worker("Antanas", "Parselis", 1991, 2000, "Informatikas"),
        new Worker("Pavel", "Kisko", 1992, 1000, "Informacines technologijos"),  new Worker("Miroslav", "Baliukonis", 1991, 2500, "Programu Sistemos"), NULL };
        Stack<Worker*> * st = new Stack<Worker*>();
        Stack<Worker*> * stack = new Stack<Worker*>(workers);      
        Worker * worker = new Worker("Edita", "Mazeikite", 1990, 4000, "Informatikas");
        
        st->push(worker);
        Worker * temp = st->pop();
        std::cout << stack->getSize() << "\n";
        Worker * temp2 = stack->pop();
        std::cout << stack->getSize() << "\n";
        delete st;
        delete stack;
        printWorker(temp);
        printWorker(temp2);
    }
    catch(Exception * exception)
    {
        std::cout << exception->getMessage() << std::endl;
    }
    
}
