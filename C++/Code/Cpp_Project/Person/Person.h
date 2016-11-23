
#ifndef PERSON_H
#define PERSON_H

#include <string>

class Person
{
private:
    std::string name;
    std::string surname;
    int birthYear;

public:
    Person(){};
    Person(std::string name, std::string surname, int birthYear);
    std::string getName() const;
    std::string getSurname() const;
    int getAge() const;
    
};


#endif