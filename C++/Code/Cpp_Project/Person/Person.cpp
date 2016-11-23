#include "Person.h"
#include "../Macros/Macros.h"
#include <iostream>

Person::Person(std::string name, std::string surname, int birthYear)
{
    this->name = name;
    this->surname = surname;
    WRONG_DATE(birthYear);
    this->birthYear = birthYear;
}

//-----------------------------------------------------------------------------

std::string Person::getName() const
{
    return name;
}

//-----------------------------------------------------------------------------

std::string Person::getSurname() const
{
    return surname;
}

//-----------------------------------------------------------------------------

int Person::getAge() const
{
    return 2011 - birthYear;
}