import 'package:flutter_test/flutter_test.dart';
import 'package:punto_venta_dolores/dominio/dinero.dart';
import 'package:punto_venta_dolores/dominio/producto.dart';
import 'package:punto_venta_dolores/dominio/carrito.dart';
import 'package:punto_venta_dolores/dominio/excepciones.dart';

// Ayudante para no repetir código
Producto nieve([int existencias = 10]) => Producto(
  codigo: 'NV-001',
  nombre: 'Nieve',
  precioCentavos: 2500,
  existencias: existencias,
);

void main() {
  group('Dinero', () {
    test('formatea centavos', () {
      expect(formatearPesos(0), '\$0.00');
      expect(formatearPesos(5), '\$0.05');
      expect(formatearPesos(123456), '\$1,234.56');
    });

    test('convierte texto a centavos', () {
      expect(pesosACentavos('12.5'), 1250);
      expect(pesosACentavos('\$1,200'), 120000);
      expect(pesosACentavos('0.07'), 7);
    });

    test('rechaza texto invalido', () {
      expect(() => pesosACentavos(''), throwsFormatException);
      expect(() => pesosACentavos('1.2.3'), throwsFormatException);
    });
  });

  group('Producto', () {
    test('ida y vuelta a mapa conserva los datos', () {
      const original = Producto(
        codigo: 'NV-001',
        nombre: 'Nieve de limón',
        precioCentavos: 2500,
        existencias: 10,
      );
      final copia = Producto.desdeMapa(original.aMapa());
      expect(copia.codigo, 'NV-001');
      expect(copia.precioCentavos, 2500);
    });

    test('copiarCon cambia solo lo indicado', () {
      const p = Producto(
        codigo: 'A',
        nombre: 'X',
        precioCentavos: 100,
        existencias: 5,
      );
      final q = p.copiarCon(existencias: 4);
      expect(q.existencias, 4);
      expect(q.precioCentavos, 100);
    });
  });

  group('Carrito', () {
    test('suma cantidades del mismo producto', () {
      final c = Carrito();
      c.agregar(nieve());
      c.agregar(nieve());
      expect(c.lineas.single.cantidad, 2);
      expect(c.totalCentavos, 5000);
    });

    // Ciclo 3.2
    test('no excede existencias', () {
      final c = Carrito();
      c.agregar(nieve(1));
      expect(
        () => c.agregar(nieve(1)),
        throwsA(isA<ExistenciasInsuficientesException>()),
      );
    });
  });
}
