//
//  UserT.swift
//  DietSupport
//
//  Created by kenji imoto on 2016/07/14.
//  Copyright © 2016年 TMS. All rights reserved.
//

import UIKit

struct ConstStruct {
    static let main_color_red: CGFloat = 0.00
    static let main_color_green: CGFloat = 0.40
    static let main_color_blue: CGFloat = 1.00
    static let main_title_color_red: CGFloat = 1.00
    static let main_title_color_green: CGFloat = 1.00
    static let main_title_color_blue: CGFloat = 1.00
    static let btn_color_red: CGFloat = 0.00
    static let btn_color_green: CGFloat = 0.40
    static let btn_color_blue: CGFloat = 1.00
    /*
    static let back_color_red: CGFloat = 0.96
    static let back_color_green: CGFloat = 0.96
    static let back_color_blue: CGFloat = 0.96
 */
    static let back_color_red: CGFloat = 0.95
    static let back_color_green: CGFloat = 0.95
    static let back_color_blue: CGFloat = 0.95
    static let main2_color_red: CGFloat = 0.00
    static let main2_color_green: CGFloat = 0.40
    static let main2_color_blue: CGFloat = 1.00
    static let cal_color_red: CGFloat = 0.69
    static let cal_color_green: CGFloat = 0.77
    static let cal_color_blue: CGFloat = 0.87
    
    static let site_url: String = "http://eserve.sakura.ne.jp/diet/"
    static let get_version_url: String = "indexJson.php"
    static let get_category_url: String = "getCategory.php"
    static let get_workout_url: String = "getWorkout.php"
    static let user_edit_url: String = "editUser.php"
    static let get_menu_url: String = "getMenu.php"
    static let get_advice_url: String = "getAdvice.php"
    static let info_1: String = "info_1"
    static let ballon_1: String = "ballon_1"
    static let ballon_2: String = "ballon_2"
    static let ballon_3: String = "ballon_3"
    
    static let kiyaku: String = "アプリケーション利用規約\n\nこの利用規約（以下，「本規約」といいます。）は，TMS（以下，「当社」といいます。）がこのアプリ上で提供するサービス（以下，「本サービス」といいます。）の利用条件を定めるものです。登録ユーザーの皆さま（以下，「ユーザー」といいます。）には，本規約に従って，本サービスをご利用いただきます。\n\n第1条 本規約の適用・変更\n\n本規約は，ユーザーと当社との間の本サービスの利用に関わる一切の関係に適用されるものとします。\n\n第2条（禁止事項）\n\nユーザーは，本サービスの利用にあたり，以下の行為をしてはなりません。\n\n（1）法令または公序良俗に違反する行為\n（2）犯罪行為に関連する行為\n（3）当社のサーバーまたはネットワークの機能を破壊したり，妨害したりする行為\n（4）当社のサービスの運営を妨害するおそれのある行為\n（5）他のユーザーに関する個人情報等を収集または蓄積する行為\n（6）他のユーザーに成りすます行為\n（7）当社のサービスに関連して，反社会的勢力に対して直接または間接に利益を供与する行為\n（8）その他，当社が不適切と判断する行為\n\n第3条（本サービスの提供の停止等）\n\n当社は，以下のいずれかの事由があると判断した場合，ユーザーに事前に通知することなく本サービスの全部または一部の提供を停止または中断することができるものとします。\n\n（1）本サービスにかかるコンピュータシステムの保守点検または更新を行う場合\n（2）地震，落雷，火災，停電または天災などの不可抗力により，本サービスの提供が困難となった場合\n（3）コンピュータまたは通信回線等が事故により停止した場合\n（4）その他，当社が本サービスの提供が困難と判断した場合\n\n当社は，本サービスの提供の停止または中断により，ユーザーまたは第三者が被ったいかなる不利益または損害について，理由を問わず一切の責任を負わないものとします。\n\n第4条（利用制限および登録抹消）\n\n当社は，以下の場合には，事前の通知なく，ユーザーに対して，本サービスの全部もしくは一部の利用を制限し，またはユーザーとしての登録を抹消することができるものとします。\n\n（1）本規約のいずれかの条項に違反した場合\n（2）登録事項に虚偽の事実があることが判明した場合\n（3）その他，当社が本サービスの利用を適当でないと判断した場合\n当社は，本条に基づき当社が行った行為によりユーザーに生じた損害について，一切の責任を負いません。\n\n第5条（免責事項）\n\n・当社の債務不履行責任は，当社の故意または重過失によらない場合には免責されるものとします。\n・当社は，何らかの理由によって責任を負う場合にも，通常生じうる損害の範囲内かつ有料サービスにおいては代金額（継続的サービスの場合には1か月分相当額）の範囲内においてのみ賠償の責任を負うものとします。\n・当社は，本サービスに関して，ユーザーと他のユーザーまたは第三者との間において生じた取引，連絡または紛争等について一切責任を負いません。\n\n第6条（サービス内容の変更等）\n\n当社は，ユーザーに通知することなく，本サービスの内容を変更しまたは本サービスの提供を中止することができるものとし，これによってユーザーに生じた損害について一切の責任を負いません。\n\n第7条（利用規約の変更）\n\n当社は，必要と判断した場合には，ユーザーに通知することなくいつでも本規約を変更することができるものとします。\n\n第8条（通知または連絡）\n\nユーザーと当社との間の通知または連絡は，当社の定める方法によって行うものとします。\n\n第9条（権利義務の譲渡の禁止）\n\nユーザーは，当社の書面による事前の承諾なく，利用契約上の地位または本規約に基づく権利もしくは義務を第三者に譲渡し，または担保に供することはできません。\n\n第10条（準拠法・裁判管轄）\n\n本規約の解釈にあたっては，日本法を準拠法とします。\n本サービスに関して紛争が生じた場合には，当社の本店所在地を管轄する裁判所を専属的合意管轄とします。\n\n制定日　　2017年2月1日\n\nTMS"
    
    static let privacy_policy: String = "TMS（以下，「当社」といいます。）は，本アプリ上で提供するサービス（以下,「本サービス」といいます。）におけるプライバシー情報の取扱いについて，以下のとおりプライバシーポリシー（以下，「本ポリシー」といいます。）を定めます。\n\n第1条（プライバシー情報）\n\n1.プライバシー情報のうち「個人情報」とは，個人情報保護法にいう「個人情報」を指すものとし，生存する個人に関する情報であって，当該情報に含まれる氏名，生年月日，住所，電話番号，連絡先その他の記述等により特定の個人を識別できる情報を指します。\n\n2.プライバシー情報のうち「履歴情報および特性情報」とは，上記に定める「個人情報」以外のものをいい，ご利用いただいたサービスやご購入いただいた商品，ご覧になったページや広告の履歴，ユーザーが検索された検索キーワード，ご利用日時，ご利用の方法，ご利用環境，郵便番号や性別，職業，年齢，ユーザーのIPアドレス，クッキー情報，位置情報，端末の個体識別情報などを指します。\n\n第２条（プライバシー情報の収集方法）\n\n1.当社は，ユーザーが利用登録をする際に氏名，生年月日，住所，電話番号，メールアドレス，銀行口座番号，クレジットカード番号，運転免許証番号などの個人情報をお尋ねすることがあります。また，ユーザーと提携先などとの間でなされたユーザーの個人情報を含む取引記録や，決済に関する情報を当社の提携先（情報提供元，広告主，広告配信先などを含みます。以下，｢提携先｣といいます。）などから収集することがあります。\n\n2.当社は，ユーザーについて，利用したサービスやソフトウエア，購入した商品，閲覧したページや広告の履歴，検索した検索キーワード，利用日時，利用方法，利用環境（携帯端末を通じてご利用の場合の当該端末の通信状態，利用に際しての各種設定情報なども含みます），IPアドレス，クッキー情報，位置情報，端末の個体識別情報などの履歴情報および特性情報を，ユーザーが当社や提携先のサービスを利用しまたはページを閲覧する際に収集します。\n\n第３条（個人情報を収集・利用する目的）\n\n当社が個人情報を収集・利用する目的は，以下のとおりです。\n\n（1）ユーザーに自分の登録情報の閲覧や修正，利用状況の閲覧を行っていただくために，氏名，住所，連絡先，支払方法などの登録情報，利用されたサービスや購入された商品，およびそれらの代金などに関する情報を表示する目的\n（2）ユーザーにお知らせや連絡をするためにメールアドレスを利用する場合やユーザーに商品を送付したり必要に応じて連絡したりするため，氏名や住所などの連絡先情報を利用する目的\n（3）ユーザーの本人確認を行うために，氏名，生年月日，住所，電話番号，銀行口座番号，クレジットカード番号，運転免許証番号，配達証明付き郵便の到達結果などの情報を利用する目的\n（4）ユーザーに代金を請求するために，購入された商品名や数量，利用されたサービスの種類や期間，回数，請求金額，氏名，住所，銀行口座番号やクレジットカード番号などの支払に関する情報などを利用する目的\n（5）ユーザーが簡便にデータを入力できるようにするために，当社に登録されている情報を入力画面に表示させたり，ユーザーのご指示に基づいて他のサービスなど（提携先が提供するものも含みます）に転送したりする目的\n（6）代金の支払を遅滞したり第三者に損害を発生させたりするなど，本サービスの利用規約に違反したユーザーや，不正・不当な目的でサービスを利用しようとするユーザーの利用をお断りするために，利用態様，氏名や住所など個人を特定するための情報を利用する目的\n（7）ユーザーからのお問い合わせに対応するために，お問い合わせ内容や代金の請求に関する情報など当社がユーザーに対してサービスを提供するにあたって必要となる情報や，ユーザーのサービス利用状況，連絡先情報などを利用する目的\n（8）上記の利用目的に付随する目的\n\n第４条（個人情報の第三者提供）\n\n1.当社は，次に掲げる場合を除いて，あらかじめユーザーの同意を得ることなく，第三者に個人情報を提供することはありません。ただし，個人情報保護法その他の法令で認められる場合を除きます。\n\n（1）法令に基づく場合\n（2）人の生命，身体または財産の保護のために必要がある場合であって，本人の同意を得ることが困難であるとき\n（3）公衆衛生の向上または児童の健全な育成の推進のために特に必要がある場合であって，本人の同意を得ることが困難であるとき\n（4）国の機関もしくは地方公共団体またはその委託を受けた者が法令の定める事務を遂行することに対して協力する必要がある場合であって，本人の同意を得ることにより当該事務の遂行に支障を及ぼすおそれがあるとき\n（5）予め次の事項を告知あるいは公表をしている場合\n・利用目的に第三者への提供を含むこと\n・第三者に提供されるデータの項目\n・第三者への提供の手段または方法\n・本人の求めに応じて個人情報の第三者への提供を停止すること\n\n2.前項の定めにかかわらず，次に掲げる場合は第三者には該当しないものとします。\n\n（1）当社が利用目的の達成に必要な範囲内において個人情報の取扱いの全部または一部を委託する場合\n（2）合併その他の事由による事業の承継に伴って個人情報が提供される場合\n（3）個人情報を特定の者との間で共同して利用する場合であって，その旨並びに共同して利用される個人情報の項目，共同して利用する者の範囲，利用する者の利用目的および当該個人情報の管理について責任を有する者の氏名または名称について，あらかじめ本人に通知し，または本人が容易に知り得る状態に置いているとき\n\n第５条（プライバシーポリシーの変更）\n\n1.本ポリシーの内容は，ユーザーに通知することなく，変更することができるものとします。\n2.当社が別途定める場合を除いて，変更後のプライバシーポリシーは，本アプリに掲載したときから効力を生じるものとします。\n\nTMS"
}

class Define{

 
}

