
#ifndef STRINGSTACK_H
#define STRINGSTACK_H

class Int
{
    private:
		const int size;
		int** v; // Mūsų masyvas, tiksliau čia tik nuoroda į pirmą elementą
		int count;

    public:
    	bool insert(int* val);
		const int* getNumber(int which) const;
		void printAll() const;
		bool full() const;
		bool empty() const;
		Int(int val = 100); 
		~Int();
};

#endif
