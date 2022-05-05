# Lcw_TSql

Gerçekleştirilen işlemler sırasıyla:

* Tablolar oluşturuldu. Tablolar arası ilişkiler kuruldu.
* Gerekli property'ler düzenlendi. Kısıtlar tipler verildi.
* Index'ler oluşturuldu.
* List, Search, Insert vb. işlemler gerçekleştiren Store Procedure'ler oluşturuldu.
* View'ler oluşturuldu.
* 'OrderDetail' tablosuna giriş yapıldığında 'Insert' edilmeden önce stock durumunu kontrol eden 
eğer yeterli ise 'Product' tablosunda stok azaltması ve 'Order' tablosunda toplam tutar
güncellemesi yapan aksi durumda stok yetersiz ise hiç bir işlem yapmadan hata döndüren Trigger oluşturuldu.

![Diagrams](https://www.linkpicture.com/q/Diagrams.png)

![Script](https://www.linkpicture.com/q/script.png)

![Trigger](https://www.linkpicture.com/q/trigger.png)
