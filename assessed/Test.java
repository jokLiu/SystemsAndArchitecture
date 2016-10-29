public class Test{
	public static void main(String[] args)
	{
		Test test = new Test();
		System.out.println(test.mod(8,4));	
	}

	int gcd(int m, int n){
		int result;
  if (n==0) {
    result = m;
  }
  else {
    result = gcd(n, mod(m,n));
  }
  return result;
}

	int mod(int m, int n){
		int   i = 0;
 		 while((n-i)*m>=0) {
   			 i++;
		  }
  return (i-1)*n;
		}
	
	int egcd(int a, int b) {
    if (a == 0)
        return b;

    while (b != 0) {
        if (a > b)
            a = a - b;
        else
            b = b - a;
    }

    return a;
}

	int gcd2(int p, int q) {
        if (q == 0) return p;
        else return gcd2(q, (p % q));
    }



}