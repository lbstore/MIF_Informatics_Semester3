#ifndef STRINGSTACK_H
#define STRINGSTACK_H

class Double {

	private:
		double* p;
		
	public:
		Double(double x);
		Double();
	   	~Double();
		// Copy Konstriuktorius
		Double(Double &d);
	  
	  	void print() const;
	  
	  	void set(double d);
	  	double get();

};

#endif
