#ifndef WORKER_H
#define WORKER_H

#include "../Person/Person.h"

class Worker : public Person
{
private:
    int salary;
    std::string rank;

public:
    Worker(){};
    Worker(std::string name, std::string surname, int birthYear, int salary, std::string rank);
    int getSalary() const;
    std::string getRank() const;
    void setSalary(int salary);
    
};


#endif