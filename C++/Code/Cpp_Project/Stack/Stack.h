
#ifndef STACK_H
#define STACK_H

#include "../Exception/Exception.h"
#include "../Macros/Macros.h"
#include <string>
#define MAX_LENGTH 3

template <class T>
class Stack
{
private:
    int top;
    T * array ;
    
public:
    Stack()
    {
        top = 0;
        array = new T[MAX_LENGTH];
    }
//-----------------------------------------------------------------------------

    Stack(T array[])
    {
        this->array = new T[MAX_LENGTH];
        for (top = 0; array[top] != NULL; top++)
        {
            this->array[top] = array[top];
        }
        
    }
//-----------------------------------------------------------------------------
    
    ~Stack()
    {
        delete [] array;
    }
    
//-----------------------------------------------------------------------------

    bool isFull() const
    {
        return top == MAX_LENGTH;
    }
    
//-----------------------------------------------------------------------------
        

    bool isEmpty() const
    {
        return top == 0;
    }
        
//-----------------------------------------------------------------------------

    int getSize() const
    {
        return top;
    }
        
//-----------------------------------------------------------------------------

    void push(T value)
    {
        if(!isFull())
        {
            array[top++] = value;
        }
        else
        {
            throw new Exception("Stekas pilnas.");
        }
    }

//-----------------------------------------------------------------------------

    T pop()
    {
        if(!isEmpty())
        {
            return (array[--top]);
        }
        else
        {
            throw new Exception("Stekas tuščias.");
        }
                    
    }
    
};


#endif