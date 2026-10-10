"""Import supplied transparent artwork intact; these resources only decorate credits."""
import add_royal_interiors as res
from evento_project import save

if __name__ == '__main__':
    count=0
    for name,file in [('spr_credit_cabeludo','Cabeludo0.png'),
                      ('spr_credit_adao','Adao0.png'),('spr_credit_akatsuki','Akatsuki0.png'),
                      ('spr_credit_yandere','Yandere0.png')]:
        source=res.ROOT/'output/credits'/file
        if source.exists() and not (res.ROOT/'sprites'/name/(name+'.yy')).exists():
            res.sprite(name,source);count+=1
    save(res.ROOT/'ParadoxoDeWilson.yyp',res.PROJECT)
    print(f'Imported {count} supplied credit-only variants; no room instances added.')
