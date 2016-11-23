#include "Worker.h"

Worker::Worker(std::string name, std::string surname, int birthYear, int salary, std::string rank)
:Person(name, surname, birthYear)
{
    this->salary = salary;
    this->rank = rank;
}

//-----------------------------------------------------------------------------

std::string Worker::getRank() const
{
    return rank;
}

//-----------------------------------------------------------------------------

int Worker::getSalary() const
{
    return salary;
}

//-----------------------------------------------------------------------------

void Worker::setSalary(int salary)
{
    this->salary = salary;
}

